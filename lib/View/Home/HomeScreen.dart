import 'package:chat_app/Controller/HomeController.dart';
import 'package:chat_app/Controller/MessageGroupController.dart';
import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  var delete = Get.delete<HomeController>();
  var controller = Get.put(HomeController());
  Size size = Size(0, 0);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        length: 2, // Số lượng tab
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Màn hình chính',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: UtilColor.textBase),
                )),
            SizedBox(
              height: 10,
            ),
            Utils.textFieldCustom(
                icon: Icon(Icons.search), hintText: 'Nhập tìm kiếm'),
            Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: UtilColor.textBase,
                labelColor: UtilColor.textBase,
                tabs: [
                  Tab(text: 'Nhóm', icon: Icon(Icons.group)),
                  Tab(
                    text: 'Cá nhân',
                    icon: Icon(Icons.person),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab nhóm
                  buildGroupTab(context),
                  // Tab cá nhân
                  buildPersonalTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGroupTab(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hội nhóm',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: UtilColor.textBase),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigation.navigateTo(page: 'CreateGroup');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: UtilColor.buttonBlack,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              height: 30,
                              width: 60,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.listGroup.isEmpty
                          ? Utils.noData()
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  controller.refressGroup();
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.listGroup.length,
                                  itemBuilder: (context, index) {
                                    return groupChat(
                                        controller.listGroup[index], index);
                                  },
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget buildPersonalTab(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Cá nhân',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: UtilColor.textBase),
                        )),
                    Obx(
                      () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            controller.refressGroup();
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listGroup.length,
                            itemBuilder: (context, index) {
                              return singleChat(controller.listGroup[index]);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget groupChat(MDGroup group, int index) {
    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<MessageGroupController>()) {
          Get.find<MessageGroupController>().createStart();
        }
        Navigation.navigateTo(page: 'MessageGroup', arguments: group);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              '${group.image}',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    height: 50,
                    width: 50,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                    color: UtilColor.buttonBlue,
                    child: Center(
                      child: Text(
                        group.name!.isEmpty ? 'A' : group.name![0],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
              },
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: UtilColor.buttonGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    group.name ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UtilColor.textPurple),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  controller.messageList.isNotEmpty
                      ? Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '${controller.messageList[index].name}: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: UtilColor.textBase),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${controller.messageList[index].content}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: UtilColor.textBase),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                controller.convertDateTimeFormat(controller
                                    .messageList[index].time
                                    .toString()),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: UtilColor.textGrey),
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget singleChat(MDGroup group) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipOval(
            child: Image.network(
              '${group.image}',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    height: 50,
                    width: 50,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                    color: UtilColor.buttonBlue,
                    child: Center(
                      child: Text(
                        group.name!.isEmpty ? 'A' : group.name![0],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
              },
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: UtilColor.buttonGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    group.name ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UtilColor.textBase),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
