import 'package:chat_app/Model/MDMessage.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MessageSingleController extends GetxController {
  TextEditingController textEditingMessage = TextEditingController();
  RxList<MDMessage> messageList = RxList<MDMessage>();
  RxString uuid = "".obs;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    uuid.value = await Utils.getStringValueWithKey('id');
    SocketIOCaller.getInstance().socket?.on('chat message', (data) {
      sendChat();
      messageList.add(MDMessage.fromJson(data));
    });
  }

  void sendChat() async {
    var body = {
      "content": textEditingMessage.text,
      "image": "",
      "id_group": Get.arguments.id,
      "id_user": await Utils.getStringValueWithKey('id')
    };
    var response = await APICaller.getInstance().post('chat', body);
    if (response != null) {
      print('Gửi thành công');
    }
  }
}
