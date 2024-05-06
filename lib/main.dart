import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/View/Splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  SocketIOCaller.getInstance().connectToServer();

  AwesomeNotifications().initialize(null,[NotificationChannel(channelKey: 'Key', channelName: 'KeyName', channelDescription: 'ABC')],debug: true);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}

