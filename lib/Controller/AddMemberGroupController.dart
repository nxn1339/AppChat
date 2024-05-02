import 'package:chat_app/Controller/MessageGroupDetailController.dart';
import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:get/get.dart';

class AddMemberGroupController extends GetxController {
  RxList<MDUser> listUser = RxList<MDUser>();
  RxList<String> listIDUser = RxList<String>();
  List<String> listIDUserInGroup = [];
  Rx<MDGroup> group = new MDGroup().obs;
  String uuid = '';
  @override
  void onInit() {
    super.onInit();
    group = Get.arguments;
    fecthMember();
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

  void refreshMember() {
    listUser.clear();
    fecthMember();
  }

  void fecthMember() async {
    try {
      var response =
          await APICaller.getInstance().get('user/member/${group.value.id}');
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

  Future<void> addMemberInGroup() async {
    try {
      listIDUserInGroup =
          listIDUserInGroup.where((element) => !element.isEmpty).toList();

      for (var i = 0; i < listIDUserInGroup.length; i++) {
        var body = {
          "id_user": listIDUserInGroup[i],
          "id_group": group.value.id,
        };
        var response = await APICaller.getInstance().post('group/member', body);
        if (response != null) {
          if (Get.isRegistered<MessageGroupDetailController>()) {
            Get.find<MessageGroupDetailController>().refreshListUserGroup();
          }
        }
      }
    } catch (e) {
      Utils.showSnackBar(title: "Thông báo", message: 'Có lỗi xảy ra !');
    } finally {
      Get.back();
      Utils.showSnackBar(
          title: "Thông báo", message: 'Thêm thành viên thành công !');
    }
  }
}
