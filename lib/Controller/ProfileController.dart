import 'dart:io';

import 'package:chat_app/Controller/HomeController.dart';
import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  String uuid = '';
  RxBool isLoading = false.obs;
  Rx<MDUser> user = new MDUser().obs;
  TextEditingController textEditName = TextEditingController();
  TextEditingController textEditPhone = TextEditingController();
  TextEditingController textEditEmail = TextEditingController();
  TextEditingController textEditBirthDay = TextEditingController();
  String birthDay = '';
  DateTime? pickDate;
  RxInt idGender = 1.obs;
  RxList<File> imageFile = RxList<File>();
  String linkImage = '';
  @override
  void onInit() async {
    super.onInit();
    await loadSavedText();
    fecthUser();
  }

  void setGender(int value) {
    idGender.value = value;
  }

  loadSavedText() async {
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      uuid = await Utils.getStringValueWithKey('id');
    }
  }

  fecthUser() async {
    isLoading.value = true;
    try {
      var response = await APICaller.getInstance().get('user/$uuid');
      if (response != null) {
        user.value = MDUser.fromJson(response['data']);
        textEditName.text = user.value.name ?? '';
        textEditPhone.text = user.value.phone ?? '';
        textEditBirthDay.text = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(user.value.birthDay ?? ''));
        pickDate = DateTime.parse(user.value.birthDay ?? '');
        textEditEmail.text = user.value.email ?? '';
        isLoading.value = false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    pickDate = await showDatePicker(
      context: context,
      initialDate: birthDay != '' ? DateTime.parse(birthDay) : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );

    if (pickDate != null) {
      textEditBirthDay.text = DateFormat('dd/MM/yyyy').format(pickDate!);
    }
  }

  void updateProfile() async {
    await postImage();
    var body = {
      "name": textEditName.text,
      "avatar": linkImage != '' ? linkImage : user.value.avatar,
      "gender": idGender.value,
      "birth_day": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(pickDate!),
      "phone": textEditPhone.text
    };
    try {
      var response = await APICaller.getInstance().put('user/$uuid', body);
      if (response != null) {
        Utils.saveStringWithKey('name', textEditName.text);
        Utils.saveStringWithKey(
            'avatar', linkImage != '' ? linkImage : user.value.avatar ?? '');
        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().loadSavedText();
        }
        Get.back();
        Utils.showSnackBar(
            title: 'Thông báo', message: 'Chỉnh sửa thành công !');
      }
    } catch (e) {}
  }

  postImage() async {
    if (imageFile.isNotEmpty) {
      try {
        var response = await APICaller.getInstance()
            .postFile('image/single', imageFile.first);
        if (response != null) {
          linkImage = response['image'];
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void getImage(int source) async {
    if (imageFile.isNotEmpty) {
      imageFile.clear();
    }
    List<File> file = await Utils.getImagePicker(source, false);
    imageFile.addAll(file);
  }
}
