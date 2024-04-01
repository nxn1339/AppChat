import 'package:chat_app/Service/SocketIO.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MessageSingleController extends GetxController{
  TextEditingController textEditingMessage = TextEditingController();
   RxList<String> messages = [''].obs;

   @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
     SocketIOCaller.getInstance().socket?.on('chat message', (data) {
        messages.add(data);
      });
  }
  
}