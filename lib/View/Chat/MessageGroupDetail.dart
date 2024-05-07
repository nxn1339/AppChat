import 'package:chat_app/Controller/MessageGroupDetailController.dart';
import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageGroupDetail extends StatelessWidget {
  MessageGroupDetail({super.key});
  var delete = Get.delete<MessageGroupDetailController>();
  var controller = Get.put(MessageGroupDetailController());
  Size size = Size(0, 0);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0.5,
        title: Text('Thành viên trong nhóm'),
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                if (controller.isOwenGroup.value == true) {
                  Utils.showDialog(
                    title: 'Xóa nhóm ?',
                    content: Text('Bạn sẽ không thể khôi phục lại !'),
                    textCancel: 'Thoát',
                    textConfirm: 'Đồng ý',
                    onCancel: () {},
                    onConfirm: () {
                      //Xóa nhóm
                      controller.deleteGroup();
                    },
                  );
                } else {
                  Utils.showDialog(
                    title: 'Rời nhóm ?',
                    content: Text('Bạn sẽ không thể khôi phục lại !'),
                    textCancel: 'Thoát',
                    textConfirm: 'Đồng ý',
                    onCancel: () {},
                    onConfirm: () {
                      //Thoát nhóm
                      controller.leaveGrouporDeleteUser(
                          controller.uuid, 'Leave');
                    },
                  );
                }
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: controller.isOwenGroup.value == true
                      ? Icon(
                          Icons.delete,
                          color: UtilColor.buttonRed,
                        )
                      : Icon(
                          Icons.output,
                          color: UtilColor.buttonRed,
                        )),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigation.navigateTo(
                        page: 'AddMemberGroup', arguments: controller.group);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: UtilColor.buttonBlack,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    controller.getImage(0);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: UtilColor.buttonBlack,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    controller.updateGroup();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: UtilColor.buttonBlack,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Center(
                child: ClipOval(
                    child: controller.imageFile.isEmpty
                        ? Image.network(
                            '${UtilLink.BASE_URL}${controller.group.value.image}',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 6),
                                color: UtilColor.buttonBlue,
                              );
                            },
                          )
                        : Image.file(
                            controller.imageFile.first,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 6),
                                color: UtilColor.buttonBlue,
                              );
                            },
                          )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Utils.textField(
                icon: const Icon(Icons.group),
                hintText: 'Tên nhóm....',
                maxLines: 1,
                controller: controller.textEditNameGroup),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => controller.listUser.isEmpty
                  ? Utils.noData()
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          controller.refreshListUserGroup();
                        },
                        child: ListView.builder(
                          itemCount: controller.listUser.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (controller.group.value.owner !=
                                    controller.listUser[index].id) {
                                  Utils.showDialog(
                                    title: 'Loại bỏ thành viên',
                                    content: Text(
                                        'Loại bỏ ${controller.listUser[index].name} ra khỏi nhóm ?'),
                                    onCancel: () {},
                                    onConfirm: () {
                                      controller.leaveGrouporDeleteUser(
                                          controller.listUser[index].id
                                              .toString(),
                                          'DeleteUser');
                                    },
                                  );
                                }
                              },
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipOval(
                                            child: Image.network(
                                              '${UtilLink.BASE_URL}${controller.listUser[index].avatar}',
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 40,
                                                  width: 40,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5,
                                                      horizontal: 6),
                                                  color: UtilColor.buttonBlue,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              controller.listUser[index].name ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: UtilColor.textBase),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    controller.group.value.owner ==
                                            controller.listUser[index].id
                                        ? Text(
                                            'Chủ nhóm',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: UtilColor.textRed),
                                          )
                                        : Text(
                                            'Thành viên',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: UtilColor.textBlue),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
