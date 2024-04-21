import 'package:chat_app/Controller/CreateGroupController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroup extends StatelessWidget {
  CreateGroup({super.key});
  var delete = Get.delete<CreateGroupController>();
  var controller = Get.put(CreateGroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: UtilColor.buttonBlack,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Tạo nhóm mới'),
        actions: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                  child: Text(
                'Tạo',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: UtilColor.textBase),
              )))
        ],
      ),
      body: Column(
        children: [
          Utils.textField(
              icon: const Icon(Icons.group),
              hintText: 'Tên nhóm....',
              maxLines: 1),
          const SizedBox(
            height: 10,
          ),
          Utils.textFieldCustom(
              maxLines: 1,
              icon: const Icon(Icons.search),
              hintText: 'Tìm kiếm'),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => controller.listUser.isEmpty
                ? Utils.noData()
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.listUser.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.addMember(
                                controller.listUser[index].id ?? '', index);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        '${controller.listUser[index].avatar}',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                                    )
                                  ],
                                ),
                                Obx(
                                  () => controller.listIDUser[index] ==
                                          controller.listUser[index].id
                                      ? const Icon(Icons.radio_button_checked)
                                      : const Icon(Icons.radio_button_off),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
