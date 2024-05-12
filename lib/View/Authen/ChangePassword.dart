import 'package:chat_app/Controller/ChangePasswordController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final delete = Get.delete<ChangePasswordController>();
  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(
        () => Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  children: [
                    Utils.textFieldPass(
                        icon: Icon(Icons.lock_clock_rounded),
                        hintText: 'Mật khẩu cũ',
                        obscureText: controller.isHidePassOld.value,
                        controller: controller.oldPass,
                        changed: (value) {
                          if (value != '') {
                            controller.resetValidate();
                          }
                        },
                        onTap: () {
                          controller.showPass(controller.isHidePassOld);
                        }),
                    Text(
                      '${controller.oldPassValidate.value}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: UtilColor.textRed),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Utils.textFieldPass(
                        icon: Icon(Icons.lock),
                        hintText: 'Mật khẩu mới',
                        controller: controller.newPass,
                        obscureText: controller.isHidePassNew.value,
                        changed: (value) {
                          if (value != '') {
                            controller.resetValidate();
                          }
                        },
                        onTap: () {
                          controller.showPass(controller.isHidePassNew);
                        }),
                    Text(
                      '${controller.newPassValidate.value}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: UtilColor.textRed),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Utils.textFieldPass(
                        icon: Icon(Icons.lock_reset),
                        hintText: 'Nhập lại',
                        controller: controller.againPass,
                        obscureText: controller.isHidePassAgain.value,
                        changed: (value) {
                          if (value != '') {
                            controller.resetValidate();
                          }
                        },
                        onTap: () {
                          controller.showPass(controller.isHidePassAgain);
                        }),
                    Text(
                      '${controller.againPassValidate.value}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: UtilColor.textRed),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.checkChangePass();
                      },
                      icon: Icon(Icons.change_circle),
                      label: Text('Thay đổi'),
                    )
                  ],
                )))
              ],
            )),
      ),
    );
  }
}
