import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:get/get.dart';

class MessageGroupDetailController extends GetxController {
  MDGroup group = new MDGroup();
  RxList<MDUser> listUser = RxList<MDUser>();
  @override
  void onInit() {
    super.onInit();
    group = Get.arguments;
    fechListUserGroup();
  }

  void fechListUserGroup() async {
    try {
      var response =
          await APICaller.getInstance().get('group/member/${Get.arguments.id}');
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
}
