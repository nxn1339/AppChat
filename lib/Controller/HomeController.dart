import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<MDGroup> listGroup = RxList<MDGroup>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fecthGroup();
  }

  void fecthGroup() async {
    try {
      var response = await APICaller.getInstance()
          .get('group/b5b3190c-5397-11ee-b610-089798d3');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDGroup.fromJson(json)).toList();
        listGroup.addAll(listItem);
        listGroup.refresh();
        print(response);
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
