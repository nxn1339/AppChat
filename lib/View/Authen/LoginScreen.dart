import 'package:chat_app/Controller/LoginController.dart';
import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:chat_app/View/Group/CreateGroup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  var delete = Get.delete<LoginController>();
  var controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0,
      ),
      body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          'Đăng nhập\nTài khoản của bạn',
                          style: TextStyle(
                              fontSize: 24,
                              color: UtilColor.textBase,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Utils.textField(
                            icon: Icon(Icons.person),
                            hintText: 'Nhập tài khoản',
                            maxLines: 1,
                            controller: controller.textEditUserName),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => Utils.textFieldPass(
                              icon: Icon(Icons.lock),
                              controller: controller.textEditPassword,
                              hintText: 'Nhập mật khẩu',
                              changed: (value) {},
                              onTap: () {
                                controller.changeShowPass();
                              },
                              obscureText: !controller.isShowPass.value),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigation.navigateTo(page: 'RegisterScreen');
                          },
                          child: Align(
                            alignment: FractionalOffset.centerRight,
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                  const TextSpan(text: 'Tạo tài khoản mới? '),
                                  TextSpan(
                                      text: 'Đăng ký',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: UtilColor.textBase,
                                          fontWeight: FontWeight.w800))
                                ],
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: UtilColor.textGrey))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    controller.login();
                    LoadingDialog.showLoadingDialog(context);
                  },
                  child: Utils.buttonBlack(context, 'Đăng nhập')),
            ],
          )),
    );
  }
}
