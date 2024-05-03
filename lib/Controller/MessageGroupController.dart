import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDMessage.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageGroupController extends GetxController {
  TextEditingController textEditingMessage = TextEditingController();
  RxList<MDMessage> messageList = RxList<MDMessage>();
  RxString uuid = "".obs;
  ScrollController scrollController = ScrollController();
  Rx<MDGroup> group = new MDGroup().obs;
  @override
  void onInit() async {
    super.onInit();
    createStart();
    SocketIOCaller.getInstance().socket?.on('chat message', (data) {
      sendChat();
      messageList.add(MDMessage.fromJson(data));
      scrollChat();
    });
  }

  void createStart() async {
    if (messageList.isNotEmpty) {
      messageList.clear();
    }
    uuid.value = await Utils.getStringValueWithKey('id');
    group.value = await Get.arguments;
    fechListChat();
  }

  void fechListChat() async {
    try {
      var response =
          await APICaller.getInstance().get('chat/${Get.arguments.id}');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDMessage.fromJson(json)).toList();
        messageList.addAll(listItem);
        messageList.refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  void sendChat() async {
    var body = {
      "content": textEditingMessage.text,
      "image": "",
      "id_group": Get.arguments.id,
      "id_user": await Utils.getStringValueWithKey('id')
    };
    var response = await APICaller.getInstance().post('chat', body);
    if (response != null) {
      textEditingMessage.clear();
      print('Gửi thành công');
    }
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

  void scrollChat() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 100,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
