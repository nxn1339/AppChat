import 'dart:async';

import 'package:chat_app/Controller/HomeController.dart';
import 'package:chat_app/Controller/LoginController.dart';
import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:chat_app/View/Group/CreateGroup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {
  RxList<MDUser> listUser = RxList<MDUser>();
  RxList<String> listIDUser = RxList<String>();
  List<String> listIDUserInGroup = [];
  TextEditingController textEditNameGroup = TextEditingController();
  String uuid = '';
  RxBool isLoading = false.obs;
  TextEditingController search = TextEditingController();
  Timer? _debounce;
  @override
  void onInit() {
    super.onInit();
    fecthUser();
    loadSavedText();
  }

  loadSavedText() async {
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      uuid = await Utils.getStringValueWithKey('id');
    }
  }

  void addMember(String id, int index) {
    if (id == listIDUser[index]) {
      listIDUser[index] = '';
    } else {
      listIDUser[index] = id;
    }
    listIDUser.refresh();
    listIDUserInGroup = listIDUser;
  }

  fecthUser() async {
    try {
      var response =
          await APICaller.getInstance().get('user/?keyword=${search.text}');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDUser.fromJson(json)).toList();
        listUser.addAll(listItem);
        listUser.refresh();
        listIDUser = RxList.generate(listUser.length, (index) => '');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMemberInGroup(String idGroup) async {
    try {
      listIDUserInGroup =
          listIDUserInGroup.where((element) => element.isNotEmpty).toList();

      for (var i = 0; i < listIDUserInGroup.length; i++) {
        var body = {
          "id_user": listIDUserInGroup[i],
          "id_group": idGroup,
        };
        var response = await APICaller.getInstance().post('group/member', body);
      }
    } catch (e) {
      Utils.showSnackBar(title: "Thông báo", message: 'Có lỗi xảy ra !');
    }
  }

  Future<void> createGroup(BuildContext context) async {
    if (textEditNameGroup.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Tên nhóm không được để trống !');
      return;
    }
    LoadingDialog.showLoadingDialog(context);
    isLoading.value = true;
    try {
      var body = {
        "name": textEditNameGroup.text,
        "image": "",
        "id_user": uuid,
        "type": 0,
        "id_user_single": ""
      };

      var response = await APICaller.getInstance().post('group', body);
      if (response != null) {
        if (response['data']['MAX(id)'] != null) {
          await addMemberInGroup(response['data']['MAX(id)']);
        }
        if (Get.isRegistered<HomeController>()) {
          var homeController = Get.find<HomeController>();
          homeController.refressGroup();
        }
        Future.delayed(Duration(seconds: 2), () {
          Get.close(2);
          Utils.showSnackBar(
              title: "Thông báo", message: 'Thêm thành công Group');
          isLoading.value = false;
        });
      }
    } catch (e) {
      Utils.showSnackBar(title: "Thông báo", message: 'Có lỗi xảy ra !');
    }
  }

  void refreshUser() async {
    if (listUser.isNotEmpty) {
      listUser.clear();
    }
    await fecthUser();
  }

  onSearchGroupChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      refreshUser();
    });
  }
}
