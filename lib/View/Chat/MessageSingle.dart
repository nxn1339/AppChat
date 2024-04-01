import 'package:chat_app/Controller/MessageSingleController.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSingle extends StatelessWidget {
  MessageSingle({super.key});
  var delete = Get.delete<MessageSingleController>();
  var controller = Get.put(MessageSingleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  return Container(
                   
                    child: Text(controller.messages[index]                
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Utils.textFieldCustom(
                          icon: Icon(Icons.file_present),
                          controller: controller.textEditingMessage,hintText: "Nhắn tin"),
                    )),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(controller.textEditingMessage.text);
                    controller.textEditingMessage.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _sendMessage(String message) {
  if (message.isNotEmpty) {
    SocketIOCaller.getInstance().socket?.emit('chat message', message);
  }
}
