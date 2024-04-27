import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController textEditUserName = TextEditingController();
  TextEditingController textEditPassword = TextEditingController();
  RxBool isShowPass = false.obs;

  void changeShowPass() {
    isShowPass.value = !isShowPass.value;
  }

  //hàm login
  void login() async {
    var body = {
      "username": textEditUserName.text,
      "password": textEditPassword.text
    };
    try {
      var response = await APICaller.getInstance().post('user/login', body);
      if (response != null) {
        Navigation.navigateTo(page: 'HomeScreen');
        saveUser(response);
        Utils.showSnackBar(
            title: "Thông báo", message: "Đăng nhập thành công !");
      } else {
        Utils.showSnackBar(title: 'Thông báo', message: response['message']);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  void saveUser(var response) {
    Utils.saveStringWithKey('id', response['data']['id']);
    Utils.saveStringWithKey('name', response['data']['name']);
    Utils.saveStringWithKey('avatar', response['data']['avatar']);
    Utils.saveStringWithKey('token', response['data']['token']);
  }
}
