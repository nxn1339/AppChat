import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDMessage.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxList<MDGroup> listGroup = RxList<MDGroup>();
  RxList<MDMessage> messageList = RxList<MDMessage>();
  String uuid = '';

  @override
  void onInit() async {
    super.onInit();
    await loadSavedText();
    await fecthGroup();
    fecthLastChat();
  }

  loadSavedText() async {
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      uuid = await Utils.getStringValueWithKey('id');
    }
  }

  fecthGroup() async {
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

  void fecthLastChat() async {
    try {
      for (var i = 0; i < listGroup.length; i++) {
        var response =
            await APICaller.getInstance().get('chat/last/${listGroup[i].id}');
        if (response != null) {
          List<dynamic> list = response['data'];
          var listItem =
              list.map((dynamic json) => MDMessage.fromJson(json)).toList();
          messageList.addAll(listItem);
          messageList.refresh();
        }
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  String convertDateTimeFormat(String inputDateTime) {
    // Định nghĩa định dạng của ngày tháng vào
    DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");

    // Định nghĩa định dạng của ngày tháng đầu ra
    DateFormat outputFormat = DateFormat("yyyy/MM/dd HH:mm");

    // Chuyển đổi ngày tháng từ định dạng đầu vào thành DateTime
    DateTime dateTime = inputFormat.parse(inputDateTime.substring(0, 23));

    // Kiểm tra xem ngày hiện tại có trùng với ngày trong chuỗi không
    DateTime currentDate = DateTime.now();
    if (dateTime.year == currentDate.year &&
        dateTime.month == currentDate.month &&
        dateTime.day == currentDate.day) {
      // Nếu là ngày hiện tại, chỉ hiển thị giờ
      outputFormat = DateFormat("HH:mm");
    }

    // Chuyển đổi DateTime thành chuỗi với định dạng mong muốn
    String outputDateTime = outputFormat.format(dateTime);

    return outputDateTime;
  }

  void refressGroup() async {
    listGroup.clear();
    await fecthGroup();
    messageList.clear();
    fecthLastChat();
  }
}
