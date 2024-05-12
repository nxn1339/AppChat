import 'package:chat_app/Controller/RegisterController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final delete = Get.delete<RegisterController>();
  final controller = Get.put(RegisterController());
  Size size = const Size(0, 0);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Đăng ký'),
          backgroundColor: Colors.white,
          foregroundColor: UtilColor.buttonBlack,
          elevation: 0.5),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Utils.textField(
                        icon: const Icon(Icons.abc),
                        hintText: 'Tên',
                        maxLines: 1,
                        controller: controller.textEditName),
                    const SizedBox(
                      height: 6,
                    ),
                    Utils.textField(
                        icon: const Icon(Icons.person),
                        hintText: 'Tên đăng nhập',
                        maxLines: 1,
                        controller: controller.textEditUserName),
                    const SizedBox(
                      height: 6,
                    ),
                    Utils.textField(
                        icon: const Icon(Icons.mail),
                        hintText: 'Email',
                        maxLines: 1,
                        controller: controller.textEditEmail),
                    const SizedBox(
                      height: 6,
                    ),
                    Obx(
                      () => Utils.textFieldPass(
                        icon: const Icon(Icons.lock),
                        hintText: 'Mật khẩu',
                        controller: controller.textEditPass,
                        changed: (value) {},
                        onTap: () {
                          controller.changeShowPass();
                        },
                        obscureText: !controller.isShowPass.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.registerUser();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    color: UtilColor.buttonBlack,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: size.width,
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
