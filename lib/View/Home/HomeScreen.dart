import 'package:chat_app/Controller/HomeController.dart';
import 'package:chat_app/Controller/MessageGroupController.dart';
import 'package:chat_app/Controller/MessageSingleController.dart';
import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/UtilLink.dart';
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
      appBar: AppBar(
        title: Text('Màn hình chính'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      drawer: NavigationDrawer(),
      body: DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              controller.currentTabIndex.value = tabController.index;
            }
          });
          return Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (controller.currentTabIndex.value != 0) {
                      Navigation.navigateTo(page: 'SearchUser');
                    }
                  },
                  child: Utils.textFieldCustom(
                    icon: const Icon(Icons.search),
                    hintText: 'Nhập tìm kiếm',
                    controller: controller.search,
                    enabled: controller.currentTabIndex.value == 0,
                    onChanged: (value) {
                      controller.onSearchGroupChanged();
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Nhóm', icon: Icon(Icons.group)),
                      Tab(text: 'Cá nhân', icon: Icon(Icons.person)),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      buildGroupTab(context),
                      buildPersonalTab(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
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
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.refressGroup();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hội nhóm",
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50))),
                                height: 30,
                                width: 60,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx(
                        () => RefreshIndicator(
                          onRefresh: () async {
                            controller.refressGroup();
                          },
                          child: controller.listGroup.isEmpty
                              ? Utils.noData()
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: controller.isLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : SizedBox(
                                          height: size.width,
                                          child: ListView.builder(
                                            itemCount:
                                                controller.listGroup.length,
                                            itemBuilder: (context, index) {
                                              return groupChat(
                                                  controller.listGroup[index],
                                                  index);
                                            },
                                          ),
                                        ),
                                ),
                        ),
                      )
                    ],
                  ),
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
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.refreshSingle();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Cá nhân',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: UtilColor.textBase),
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Obx(
                        () => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              controller.refreshSingle();
                            },
                            child: controller.listGroupSingle.isEmpty ||
                                    controller.listUser.isEmpty
                                ? Utils.noData()
                                : SizedBox(
                                    height: size.width,
                                    child: ListView.builder(
                                      itemCount:
                                          controller.listGroupSingle.length,
                                      itemBuilder: (context, index) {
                                        if (controller.listUser.length >=
                                            index + 1) {
                                          return GestureDetector(
                                            onLongPress: () {
                                              Utils.showDialog(
                                                title: 'Xóa đoạn chat',
                                                content: Text(
                                                  'Bạn có chắc muốn xóa đoạn chat với ${controller.listUser[index].name} ?',
                                                  textAlign: TextAlign.center,
                                                ),
                                                onCancel: () {},
                                                onConfirm: () {
                                                  controller.deleteGroupSingle(
                                                      controller
                                                              .listGroupSingle[
                                                                  index]
                                                              .id ??
                                                          '');
                                                },
                                              );
                                            },
                                            child: singleChat(
                                                controller
                                                    .listGroupSingle[index],
                                                index),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
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
        controller.updateStatus(group.id.toString());
        Navigation.navigateTo(page: 'MessageGroup', arguments: group);
      },
      child: Obx(
        () => Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${UtilLink.BASE_URL}${group.image}',
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                      height: 60,
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 6),
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
                height: 60,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          group.name ?? "",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: UtilColor.textPurple),
                        ),
                        controller.listStatusMessage.isNotEmpty &&
                                controller.listStatusMessage.length >= index + 1
                            ? controller.listStatusMessage[index].readMessage ==
                                    1
                                //Chưa đọc tin nhắn
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: UtilColor.buttonRed,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50))),
                                    height: 10,
                                    width: 10,
                                    child: Text(controller
                                        .listStatusMessage[index].readMessage
                                        .toString()),
                                  )
                                //Đã đọc tin nhắn
                                : Container()
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    controller.messageList.isNotEmpty
                        ? controller.messageList.length > index
                            ? Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      controller.convertDateTimeFormat(
                                          controller.messageList[index].time
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
                        : Container()
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget singleChat(MDGroup group, int index) {
    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<MessageSingleController>()) {
          Get.find<MessageSingleController>().createStart();
        }
        controller.updateStatus(group.id.toString());
        Navigation.navigateTo(
            page: 'MessageSingle',
            arguments: [group, controller.listUser[index]]);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipOval(
            child: Image.network(
              '${UtilLink.BASE_URL}${controller.listUser[index].avatar}',
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
                        controller.listUser[index].name!.isEmpty
                            ? 'A'
                            : controller.listUser[index].name![0],
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
                    controller.listUser[index].name ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UtilColor.textBase),
                  ),
                  const SizedBox(
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

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({super.key});
  var controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () => Column(children: [
          const SizedBox(
            height: 50,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Image.network(
              '${UtilLink.BASE_URL}${controller.avatar.value}',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    height: 100,
                    width: 100,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                    color: UtilColor.buttonBlue,
                    child: Center(
                      child: Text(
                        controller.name.isEmpty
                            ? 'A'
                            : controller.name.value[0],
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
            height: 10,
          ),
          Text(
            controller.name.value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: UtilColor.textBase),
          ),
          const SizedBox(
            height: 50,
          ),
          Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Cá nhân',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: UtilColor.textBase),
                ),
                onTap: () {
                  Navigation.navigateTo(page: 'ProfileScreen');
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text(
                  'Đổi mật khẩu',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: UtilColor.textBase),
                ),
                onTap: () {
                  Navigation.navigateTo(page: 'ChangePassword');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_rounded),
                title: Text(
                  'Cài đặt',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: UtilColor.textBase),
                ),
                onTap: () {
                  // Handle onTap event
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Đăng Xuất',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: UtilColor.textBase),
                ),
                onTap: () {
                  controller.logOut();
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
