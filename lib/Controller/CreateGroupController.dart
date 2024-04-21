import 'package:chat_app/Model/MDUser.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {
  RxList<MDUser> listUser = RxList<MDUser>();
  RxList<String> listIDUser = RxList<String>();

  @override
  void onInit() {
    super.onInit();
    fecthGroup();
  }

  void addMember(String id, int index) {
    if (id == listIDUser[index]) {
      listIDUser[index] = '';
    } else {
      listIDUser[index] = id;
    }
    listIDUser.refresh();
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
        listIDUser = RxList.generate(listUser.length, (index) => '');
      }
    } catch (e) {
      print(e);
    }
  }
}
