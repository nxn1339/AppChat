import 'package:chat_app/Controller/SearchUserController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUser extends StatelessWidget {
  SearchUser({super.key});
  var delete = Get.delete<SearchUserController>();
  var controller = Get.put(SearchUserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Utils.textFieldCustom(
            icon: const Icon(Icons.search),
            hintText: 'Nhập tìm kiếm',
            controller: controller.search,
            onChanged: (value) {
              controller.onSearchUserChanged();
            },
          ),
          backgroundColor: Colors.white,
          foregroundColor: UtilColor.buttonBlack,
          elevation: 0.5),
      body: Column(
        children: [
          Obx(
            () => controller.listUser.isEmpty
                ? Utils.noData()
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.refreshUser();
                      },
                      child: ListView.builder(
                        itemCount: controller.listUser.length,
                        itemBuilder: (context, index) {
                          if (controller.listUser[index].id ==
                              controller.uuid) {
                            return Container();
                          } else {
                            return GestureDetector(
                              onTap: () {
                                controller.createGroup(context,
                                    controller.listUser[index].id ?? '');
                              },
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                        Text(
                                          controller.listUser[index].name ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: UtilColor.textBase),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
