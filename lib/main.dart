import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/View/Home/HomeScreen.dart';
import 'package:chat_app/View/Splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Utils/Utils.dart';

void main() async {
  SocketIOCaller.getInstance().connectToServer();

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'Key',
            channelName: 'KeyName',
            channelDescription: 'ABC')
      ],
      debug: true);
  String uuid = await Utils.getStringValueWithKey('id');
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: uuid != "" ? HomeScreen() : Splash(),
  ));
}
