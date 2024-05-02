import 'package:chat_app/Controller/HomeController.dart';
import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class MessageGroupDetailController extends GetxController {
  Rx<MDGroup> group = new MDGroup().obs;
  RxList<MDUser> listUser = RxList<MDUser>();
  String uuid = '';
  RxBool isOwenGroup = false.obs;
  @override
  void onInit() async {
    super.onInit();
    group.value = Get.arguments;

    fechListUserGroup();
    await loadSavedText();
    if (uuid == group.value.owner) {
      isOwenGroup.value = true;
    } else {
      isOwenGroup.value = false;
    }
  }

  loadSavedText() async {
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      uuid = await Utils.getStringValueWithKey('id');
    }
  }

  void fechListUserGroup() async {
    try {
      var response =
          await APICaller.getInstance().get('group/member/${group.value.id}');
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

  void refreshListUserGroup() {
    listUser.clear();
    fechListUserGroup();
  }

  Future deleteGroup() async {
    try {
      var response =
          await APICaller.getInstance().delete('group/${group.value.id}');
      if (response != null) {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().refressGroup();
        }
        Get.close(3);
        Utils.showSnackBar(title: 'Thông báo', message: 'Xóa nhóm thành công!');
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  Future leaveGrouporDeleteUser(String idUser, String action) async {
    try {
      var response =
          await APICaller.getInstance().delete('group/member/$idUser');
      if (response != null) {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().refressGroup();
        }
        if (action == 'DeleteUser') {
          listUser.removeWhere((element) => element.id == idUser);
          listUser.refresh();
          Get.back();
          Utils.showSnackBar(
              title: 'Thông báo', message: 'Xóa thành viên thành công!');
        } else {
          Get.close(3);
          Utils.showSnackBar(
              title: 'Thông báo', message: 'Rời nhóm thành công!');
        }
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }
}
