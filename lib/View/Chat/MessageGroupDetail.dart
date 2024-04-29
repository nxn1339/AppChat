import 'package:chat_app/Controller/MessageGroupDetailController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageGroupDetail extends StatelessWidget {
  MessageGroupDetail({super.key});
  var delete = Get.delete<MessageGroupDetailController>();
  var controller = Get.put(MessageGroupDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0.5,
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              'Thành viên trong nhóm',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: UtilColor.textBase),
            ),
            Obx(
              () => controller.listUser.isEmpty
                  ? Utils.noData()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.listUser.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    '${UtilLink.BASE_URL}${controller.listUser[index].avatar}',
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
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  controller.listUser[index].name ?? '',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: UtilColor.textBase),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
