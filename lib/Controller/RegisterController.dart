import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isShowPass = false.obs;
  TextEditingController textEditName = TextEditingController();
  TextEditingController textEditUserName = TextEditingController();
  TextEditingController textEditEmail = TextEditingController();
  TextEditingController textEditPass = TextEditingController();

  void changeShowPass() {
    isShowPass.value = !isShowPass.value;
  }

  registerUser() async {
    if (textEditName.text.trim().isEmpty) {
      Utils.showSnackBar(title: "Lỗi", message: 'Bạn chưa nhập tên !');
      return;
    }
    if (textEditUserName.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: "Lỗi", message: 'Bạn chưa nhập tên đăng nhập !');
      return;
    }
    if (textEditEmail.text.trim().isEmpty) {
      Utils.showSnackBar(title: "Lỗi", message: 'Bạn chưa nhập email !');
      return;
    }
    if (textEditPass.text.trim().isEmpty) {
      Utils.showSnackBar(title: "Lỗi", message: 'Bạn chưa nhập mật khẩu !');
      return;
    }

    var body = {
      "name": textEditName.text,
      "username": textEditUserName.text,
      "password": textEditPass.text,
      "email": textEditEmail.text
    };
    try {
      var response = await APICaller.getInstance().post('user/register', body);
      if (response != null) {
        Navigation.navigateGetOffAll(page: 'LoginScreen');
        Utils.showSnackBar(title: "Thông báo", message: "Đăng ký thành công !");
      } else {
        Utils.showSnackBar(title: 'Thông báo', message: response['message']);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }
}
