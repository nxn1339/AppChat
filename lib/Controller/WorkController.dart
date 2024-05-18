import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDWork.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkController extends GetxController {
  RxList<MDWork> listWork = RxList<MDWork>();
  Rx<MDGroup> group = new MDGroup().obs;
  String uuid = '';
  RxBool isLoading = false.obs;
  TextEditingController textEditNameWork = TextEditingController();
  int selectIndex = -1;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await createStart();
    fechListWork();
  }

  createStart() async {
    uuid = await Utils.getStringValueWithKey('id');
    group = await Get.arguments;
  }

  void fechListWork() async {
    isLoading.value = true;
    try {
      var response =
          await APICaller.getInstance().get('work/${group.value.id}');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDWork.fromJson(json)).toList();
        listWork.addAll(listItem);
        listWork.refresh();
        isLoading.value = false;
      }
    } catch (e) {
      print(e);
    }
  }

  void addWork() async {
    var body = {
      "name": textEditNameWork.text,
      "id_user": uuid,
      "id_group": group.value.id
    };
    try {
      var response = await APICaller.getInstance().post('work', body);
      if (response != null) {
        Get.back();
        refreshWork();
      }
    } catch (e) {
      print(e);
    }
  }

  void updateWork(String id) async {
    var body = {
      "name": textEditNameWork.text,
      "id": id,
    };
    try {
      var response = await APICaller.getInstance().put('work', body);
      if (response != null) {
        Get.close(2);
        refreshWork();
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteWork(String id) async {
    try {
      var response = await APICaller.getInstance().delete('work/$id');
      if (response != null) {
        Get.back();
        refreshWork();
      }
    } catch (e) {
      print(e);
    }
  }

  void refreshWork() async {
    isLoading.value = true;
    if (listWork.isNotEmpty) {
      listWork.clear();
    }
    textEditNameWork.text = '';
    fechListWork();
  }
}
