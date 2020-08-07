/*
* Author : LiJiqqi
* Date : 2020/8/7
*/

import 'package:flutter/material.dart';
import 'package:flutterqqim/chat_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/enums/log_print_level.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

import 'group_page.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    init();
    super.initState();
    TencentImPlugin.init(
        appid: "1400408794", logPrintLevel: LogPrintLevel.debug);
  }

  /// 初始化
  init() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.storage,
      PermissionGroup.microphone
    ]);
  }

  void login()async{
    await TencentImPlugin.login(
      identifier: "bladeofgod",
      userSig:
      "eJwtzLEOgjAUheF36WzwUlvakjggC4MuKkSMC6QFrqgQIMRofHdJYTzfSf4vOe9Pzmg64hPqAFnZjdq8BizQcv7ItGmKstHL2*s6a1vUxHcZAAMpFJsf826xM5NzzikAzDrg05ryhCc23FsqWE7xENKkTy4QR4GscFfSeyg5uodrNNbVbc1imgYfpo61ELAlvz*F1jJf",
    );

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (ctx)=>ChatPage(id: '@TGS#a2HHHJUGA',type: SessionType.Group,)));
  }

  void loginAA()async{
    await TencentImPlugin.login(
      identifier: "administrator",
      userSig:
      "eJwtzF0LgjAYBeD-suuQN5kfE7pYQlDY1YQ*7hZb8hba3FaZ0X9P1MvznMP5krIQwUtbkpEwALIYMyrdeLziyFLV2KDzVvqHnQdO3aUxqEi2pAAU0oTRqdGdQasHj6IoBIBJPdajsTiJU8ZmdVgN-5eqLMpTyuP*c74dN1Ls3HafH57YyrcI2473OTDu1kUCK-L7A2kbNPs_",
    );
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (ctx)=>ChatPage(id: '@TGS#a2HHHJUGA',type: SessionType.Group,)));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text('login'),
            onPressed: login,
          ),
          SizedBox(
            width: 1,height: 20,
          ),
          RaisedButton(
            child: Text('login 2'),
            onPressed: loginAA,
          ),
          SizedBox(
            width: 1,height: 20,
          ),
          RaisedButton(onPressed: insertUsers,
          child: Text('insert users'),)
        ],
      ),
    );
  }

  final url = 'https://console.tim.qq.com/v4/im_open_login_svc/multiaccount_import?'
      'sdkappid=1400408794&identifier=bladeofgod&usersig=xxx&random=99999999&contenttype=json';
  insertUsers() {

  }
}



















