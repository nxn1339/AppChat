import 'package:chat_app/Controller/HomeController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  var delete = Get.delete<HomeController>();
  var controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.listGroup.length,
                          itemBuilder: (context, index) {
                            return groupChat(
                                controller.listGroup[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget groupChat(Group group) {
    return Container(
      color: UtilColor.buttonGrey,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
          color: UtilColor.buttonBlue,
          child: Text(
            group.nameGroup!.isEmpty ? 'A' : group.nameGroup![0],
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.nameGroup??"",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: UtilColor.textBase),
            ),
            Row(
              children: [
                Text('${group.nameUser??'Bạn'}: ',style: TextStyle(fontSize: 13,color: UtilColor.textGrey,fontWeight: FontWeight.w500)),
                Text(group.content??'',style: TextStyle(fontSize: 13,color: UtilColor.textBase,fontWeight: FontWeight.w500),)
              ],
            ),
          ],
        )
      ]),
    );
  }
}
