import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController textEditUserName = TextEditingController();
  TextEditingController textEditPassword = TextEditingController();
  RxBool isShowPass = false.obs;

  void changeShowPass() {
    isShowPass.value = !isShowPass.value;
  }
}
