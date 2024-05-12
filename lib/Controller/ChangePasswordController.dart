import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  RxBool isHidePassOld = true.obs;
  RxBool isHidePassNew = true.obs;
  RxBool isHidePassAgain = true.obs;

  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController againPass = TextEditingController();

  RxString oldPassValidate = ''.obs;
  RxString newPassValidate = ''.obs;
  RxString againPassValidate = ''.obs;

  bool isCheckValidate = false;

  //hàm show text mật khẩu
  void showPass(RxBool isHidePass) {
    isHidePass.value = !isHidePass.value;
  }

  void checkChangePass() {
    if (oldPass.text.trim() != '' && newPass.text.trim() != '') {
      if (newPass.text.trim() == againPass.text.trim()) {
        changePass();
        isCheckValidate = true;
      } else {
        againPassValidate.value = 'Mật khẩu không giống nhau !';
      }
    } else {
      if (oldPass.text.trim() == '') {
        oldPassValidate.value = 'Mật khẩu cũ đang trống !';
        print(oldPass.text.trim());
      } else {
        oldPassValidate.value = '';
      }

      if (newPass.text.trim() == '') {
        newPassValidate.value = 'Mật khẩu mới đang trống !';
      } else {
        newPassValidate.value = '';
      }
    }
  }

  void changePass() async {
    var body = {"oldPassword": oldPass.text, "password": newPass.text};
    try {
      var response = await APICaller.getInstance().put(
          'user/change_password/${await Utils.getStringValueWithKey('id')}',
          body);
      if (response != null) {
        Get.back();
        Utils.showSnackBar(
            title: 'Thông báo', message: 'Đổi mật khẩu thành công !');
      }
    } catch (e) {}
  }

  void resetValidate() {
    oldPassValidate.value = '';
    newPassValidate.value = '';
    againPassValidate.value = '';
  }
}
