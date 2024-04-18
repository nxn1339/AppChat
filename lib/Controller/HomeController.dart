import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<MDGroup> listGroup = RxList<MDGroup>();
  String uuid = '';

  @override
  void onInit() async {
    super.onInit();
    await loadSavedText();
    fecthGroup();
  }

  loadSavedText() async {
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      uuid = await Utils.getStringValueWithKey('id');
    }
  }

  void fecthGroup() async {
    try {
      var response = await APICaller.getInstance().get('group/$uuid');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDGroup.fromJson(json)).toList();
        listGroup.addAll(listItem);
        listGroup.refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  void refressGroup() {
    listGroup.clear();
    fecthGroup();
  }
}
