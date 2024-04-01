import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/View/Splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  SocketIOCaller.getInstance().connectToServer();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}

