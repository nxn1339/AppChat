import 'package:chat_app/Controller/HomeController.dart';
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
        length: 3, // Số lượng tab
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
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Utils.textFieldCustom(
                  icon: Icon(Icons.search), hintText: 'Nhập tìm kiếm'),
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: UtilColor.textBase,
                labelColor: UtilColor.textBase,
                tabs: [
                  Tab(text: 'Tất cả', icon: Icon(Icons.all_inbox)),
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
                  buildAllTab(context),
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

  Widget buildAllTab(BuildContext context) {
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
                          'Tất cả',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: UtilColor.textBase),
                        )),
                    Obx(
                      () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.listGroup.length,
                          itemBuilder: (context, index) {
                            if (controller.listGroup[index].type == 1) {
                              return singleChat(controller.listGroup[index]);
                            }
                            return groupChat(controller.listGroup[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
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
                        child: Text(
                          'Hội nhóm',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: UtilColor.textBase),
                        )),
                    Obx(
                      () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.listGroup.length,
                          itemBuilder: (context, index) {
                            return groupChat(controller.listGroup[index]);
                          },
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.listGroup.length,
                          itemBuilder: (context, index) {
                            return singleChat(controller.listGroup[index]);
                          },
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

  Widget groupChat(Group group) {
    return GestureDetector(
      onTap: () {
        print('Nhóm');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
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
                        group.nameGroup!.isEmpty ? 'A' : group.nameGroup![0],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
              },
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: UtilColor.buttonGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    group.nameGroup ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UtilColor.textBase),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Text('${group.nameUser ?? 'Bạn'}: ',
                          style: TextStyle(
                              fontSize: 13,
                              color: UtilColor.textGrey,
                              fontWeight: FontWeight.w500)),
                      Text(
                        group.content ?? '',
                        style: TextStyle(
                            fontSize: 13,
                            color: UtilColor.textBase,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget singleChat(Group group) {
    return GestureDetector(
      onTap: () {
        Navigation.navigateTo(page: 'MessageSingle',arguments: group);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
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
                        group.nameGroup!.isEmpty ? 'A' : group.nameGroup![0],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
              },
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: UtilColor.buttonGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    group.nameUser ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UtilColor.textBase),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    group.content ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: UtilColor.textBase,
                        fontWeight: FontWeight.w500),
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
