/*
* Author : LiJiqqi
* Date : 2020/8/7
*/


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

class ChatPage extends StatefulWidget{

  /// 会话ID
  final String id;

  /// 会话类型
  final SessionType type;

  const ChatPage({
    Key key,
    this.id,
    this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }

}

class ChatPageState extends State<ChatPage> {

  /// 当前消息列表
  List<DataEntity> data = [];

  /// 滚动控制器
  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    // 添加监听器
    TencentImPlugin.addListener(listener);
  }


  @override
  void dispose() {
    super.dispose();
    TencentImPlugin.removeListener(listener);
  }

  /// 监听器
  listener(type, params) {
    debugPrint('监听');
    debugPrint('${type.toString()}----------${params.toString()}');
    // 新消息时更新会话列表最近的聊天记录
    if (type == ListenerTypeEnum.NewMessages) {
      // 更新消息列表
      this.setState(() {
        data.add(DataEntity(data: params));
        debugPrint('data  ------- ${data.last.data.toJson().toString()}');
      });
      // 设置已读
      TencentImPlugin.setRead(sessionId: widget.id, sessionType: widget.type);
    }
    ///test
    ///test
    if (type == ListenerTypeEnum.RefreshConversation) {
      for(var i in params){
        if(i is SessionEntity){
          // 更新消息列表
          debugPrint('refresh data  ${i.message.toJson().toString()}');
          if(i.message.read){
            this.setState(() {
              data.add(DataEntity(data: i.message));

            });
          }

          // 设置已读
          //TencentImPlugin.setRead(sessionId: widget.id, sessionType: widget.type);

        }
      }


    }

    // 消息上传通知
    if (type == ListenerTypeEnum.UploadProgress) {
      Map<String, dynamic> obj = jsonDecode(params);

      // 获得进度和消息实体
      int progress = obj["progress"];
      MessageEntity message = MessageEntity.fromJson(obj["message"]);

      // 更新数据
      this.updateData(DataEntity(
        data: message,
        progress: progress,
      ));
    }
  }

  /// 更新单个数据
  updateData(DataEntity dataEntity) {
    bool exist = false;
    for (var index = 0; index < data.length; index++) {
      DataEntity item = data[index];
      if (item.data == dataEntity.data) {
        this.data[index] = dataEntity;
        exist = true;
        break;
      }
    }

    if (!exist) {
      this.data.add(dataEntity);
    }

    this.setState(() {});
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        width: size.width,height: size.height,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              width: 1,height: 40,
            ),
            RaisedButton(onPressed: ()async{
              await TencentImPlugin.applyJoinGroup(groupId: widget.id
                  , reason: 'hello');

            },child: Text('join group',style: TextStyle(color: Colors.black,fontSize: 18),),),
            SizedBox(
              width: 1,height: 40,
            ),
            RaisedButton(onPressed: ()async{
              await TencentImPlugin.sendMessage(sessionId: '@TGS#a2HHHJUGA',
                sessionType: SessionType.Group, node: TextMessageNode(
                  content: 'hello !',
                ),).then((value) {
                debugPrint('msg recall  ${value.toJson().toString()}');
              });

            },child: Text('send msg',style: TextStyle(color: Colors.black,fontSize: 18),),),
            SizedBox(width: 1,height: 40,),
            Expanded(child: ListView(
              controller: scrollController,
              children: data.map((e){
                return Container(
                  width: size.width,height: 50,
                  child: Text('seq: ${e.data.seq }\n'
                      'timeStamp : ${e.data.timestamp} \n '
                      'note : ${e.data.note}',style: TextStyle(color: Colors.black),),
                );
              }).toList(),
            ))
          ],
        ),
      ),
    );
  }
}

/// 数据实体
class DataEntity {
  /// 消息实体
  final MessageEntity data;

  /// 进度
  final int progress;

  DataEntity({
    this.data,
    this.progress,
  });
}
























