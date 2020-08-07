/*
* Author : LiJiqqi
* Date : 2020/8/7
*/


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tencent_im_plugin/entity/group_info_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

class GroupList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  /// 刷新加载器
  GlobalKey<RefreshIndicatorState> refreshIndicator = GlobalKey();

  /// 数据对象
  List<GroupInfoEntity> data = [];

  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      refreshIndicator.currentState.show();
    });
  }

  /// 刷新
  Future<void> onRefresh() {
    debugPrint('refreshing');
    return TencentImPlugin.getGroupList().then((res) {
      res.forEach((element) {
        debugPrint('refresh ----- ${element.toJson().toString()}');
      });
      this.setState(() {
        data = res;

      });
    });
  }

  /// 点击事件
  onClick(item) {
//    Navigator.push(
//      context,
//      new MaterialPageRoute(
//        builder: (context) => new ImPage(
//          id: item.groupId,
//          type: SessionType.Group,
//        ),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      child: Container(
        width: size.width,height: size.height,
        child: Column(
          children: [

            GestureDetector(
              onTap: ()async{
                //进群
                await TencentImPlugin.applyJoinGroup(groupId: '@TGS#a2HHHJUGA'
                    , reason: 'hello');
              },
              child: Container(
                color: Colors.blue,
                margin: EdgeInsets.only(top: 40,bottom: 40),
                width:200,height: 40,
                child: Text('群列表'),
              ),
            ),
            
            SizedBox(
              width: 1,height: 20,
            ),
            RaisedButton(
              child: Text('发送消息'),
              onPressed: ()async{
                await TencentImPlugin.sendMessage(sessionId: '@TGS#a2HHHJUGA',
                    sessionType: SessionType.Group, node: TextMessageNode(
                    content: 'hello !',
                  ),).then((value) {
                    debugPrint('msg recall  ${value.toJson().toString()}');
                });
              },
            ),
            
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                key: refreshIndicator,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
//        children: <Widget>[],
                  children: data.map(
                        (item) {
                          debugPrint('item --------${item.toJson().toString()}');
                      return InkWell(
                        onTap: () => onClick(item),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: Image.network(
                              item.faceUrl,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                          title: Text(
                            item.groupName,
                          ),
                          subtitle: Text("${item.memberNum}人"),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




















