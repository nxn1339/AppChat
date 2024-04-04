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
        title: Column(
          children: [
            ClipOval(
              child: Image.network(
                '${Get.arguments.image}',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 6),
                      color: UtilColor.buttonBlue,
                      child: Center(
                        child: Text(
                          Get.arguments.nameUser!.isEmpty
                              ? 'A'
                              : Get.arguments.nameUser![0],
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ));
                },
              ),
            ),
            Text(
              Get.arguments.nameUser,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: UtilColor.textBase),
            )
          ],
        ),
        centerTitle: true,
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
                      decoration: BoxDecoration(
                          color: UtilColor.buttonBlue,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      padding: EdgeInsets.symmetric(vertical: 6),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            controller.messages[index],
                            style: TextStyle(color: Colors.white),
                          )));
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
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Utils.textFieldCustom(
                      icon: Icon(Icons.file_present),
                      controller: controller.textEditingMessage,
                      hintText: "Nhắn tin",
                      maxLines: 1),
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
