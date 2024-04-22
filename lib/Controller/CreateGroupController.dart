import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {
  RxList<MDUser> listUser = RxList<MDUser>();
  RxList<String> listIDUser = RxList<String>();
  List<String> listIDUserInGroup = [];
  TextEditingController textEditNameGroup = TextEditingController();
  String uuid = '';
  @override
  void onInit() {
    super.onInit();
    fecthGroup();
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

  void fecthGroup() async {
    try {
      var response = await APICaller.getInstance().get('user');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDUser.fromJson(json)).toList();
        listUser.addAll(listItem);
        listUser.refresh();
        listUser.removeWhere((element) => element.id == uuid);
        listIDUser = RxList.generate(listUser.length, (index) => '');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMemberInGroup(String idGroup) async {
    await Future.forEach(listIDUserInGroup, (element) async {
      if (element.isEmpty) {
        listIDUserInGroup.remove(element);
      }
    });
    try {
      for (var i = 0; i < listIDUserInGroup.length; i++) {
        var body = {
          "id_user": listIDUserInGroup[i],
          "id_group": idGroup,
        };
        var response = await APICaller.getInstance().post('group/member', body);
        if (response != null) {
          print('done');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void createGroup() async {
    var body = {
      "name": textEditNameGroup.text,
      "image": "",
      "id_user": uuid,
    };
    try {
      var response = await APICaller.getInstance().post('group', body);
      if (response != null) {
        await addMemberInGroup(response['data']['id']);
        Get.back();
        Utils.showSnackBar(
            title: "Thông báo", message: 'Thêm thành công Group');
      }
    } catch (e) {
      print(e);
    }
  }
}
