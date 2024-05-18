import 'dart:async';

import 'package:chat_app/Controller/HomeController.dart';
import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchUserController extends GetxController {
  RxList<MDUser> listUser = RxList<MDUser>();
  TextEditingController search = TextEditingController();
  Timer? _debounce;
  String uuid = '';
  @override
  void onInit() {
    // TODO: implement onInit
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

  void fecthUser() async {
    try {
      var response =
          await APICaller.getInstance().get('user/?keyword=${search.text}');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDUser.fromJson(json)).toList();
        listUser.addAll(listItem);
        listUser.refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> fetchCheck(String idUser) async {
    try {
      var response =
          await APICaller.getInstance().get('group/Check/$uuid/$idUser');
      if (response != null &&
          response.containsKey('data') &&
          response['data'] is List) {
        var dataList = response['data'] as List;
        if (dataList.isNotEmpty) {
          var check = dataList[0]['cnt'];
          if (check is int && check > 0) {
            return false;
          } else {
            return true;
          }
        }
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> createGroup(BuildContext context, String idUser) async {
    if (await fetchCheck(idUser) == false) {
      Get.back();
      return;
    }

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().listGroupSingle;
    }
    try {
      var body = {
        "name": "Single Chat",
        "image": "",
        "id_user": uuid,
        "type": 1,
        "id_group": "",
        "id_user_single": idUser
      };

      var response = await APICaller.getInstance().post('group', body);
      if (response != null) {
        if (response['data']['MAX(id)'] != null) {
          await addMemberInGroup(response['data']['MAX(id)'], idUser);
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().refreshSingle();
          }
          Get.back();
        }
      }
    } catch (e) {
      Utils.showSnackBar(title: "Thông báo", message: 'Có lỗi xảy ra !');
    }
  }

  Future<void> addMemberInGroup(String idGroup, String idUser) async {
    try {
      var body = {
        "id_user": idUser,
        "id_group": idGroup,
      };
      var response = await APICaller.getInstance().post('group/member', body);
      if (response != null) {
        print('OKE');
      }
    } catch (e) {
      Utils.showSnackBar(title: "Thông báo", message: 'Có lỗi xảy ra !');
    }
  }

  void refreshUser() async {
    if (listUser.isNotEmpty) {
      listUser.clear();
    }
    fecthUser();
  }

  onSearchUserChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      refreshUser();
    });
  }
}
