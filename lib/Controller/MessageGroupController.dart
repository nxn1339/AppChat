import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDMessage.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MessageGroupController extends GetxController {
  TextEditingController textEditingMessage = TextEditingController();
  RxList<MDMessage> messageList = RxList<MDMessage>();
  RxString uuid = "".obs;
  ScrollController scrollController = ScrollController();
  Rx<MDGroup> group = new MDGroup().obs;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    createStart();
    SocketIOCaller.getInstance().socket?.on('chat message', (data) {
      sendChat();
      messageList.add(MDMessage.fromJson(data));
      scrollChat();
    });
  }

  void createStart() async {
    if (messageList.isNotEmpty) {
      messageList.clear();
    }
    uuid.value = await Utils.getStringValueWithKey('id');
    group.value = await Get.arguments;
    fechListChat();
  }

  void fechListChat() async {
    try {
      var response =
          await APICaller.getInstance().get('chat/${Get.arguments.id}');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDMessage.fromJson(json)).toList();
        messageList.addAll(listItem);
        messageList.refresh();
      }
    } catch (e) {
      print(e);
    }
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
      textEditingMessage.clear();
      print('Gửi thành công');
    }
  }

  void scrollChat() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 100,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
