import 'dart:io';

import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDMessage.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MessageGroupController extends GetxController {
  TextEditingController textEditingMessage = TextEditingController();
  RxList<MDMessage> messageList = RxList<MDMessage>();
  RxString uuid = "".obs;
  ScrollController scrollController = ScrollController();
  Rx<MDGroup> group = new MDGroup().obs;
  RxList<File> imageFile = RxList<File>();
  String linkImage = '';

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

  bool isImageLink(String link) {
    // Danh sách các phần mở rộng ảnh phổ biến
    List<String> imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'tiff',
      'psd',
      'raw',
      'svg'
    ];

    // Chuyển đổi liên kết sang chữ thường để phù hợp với phần mở rộng
    String lowercaseLink = link.toLowerCase();

    // Kiểm tra xem liên kết có kết thúc bằng một trong các phần mở rộng ảnh không
    for (var extension in imageExtensions) {
      if (lowercaseLink.endsWith(extension)) {
        return true;
      }
    }

    return false;
  }

  String getFileExtension(String fileName) {
    int lastIndex = fileName.lastIndexOf('.');
    if (lastIndex != -1 && lastIndex < fileName.length - 1) {
      return fileName.substring(lastIndex + 1).toLowerCase();
    }
    return '';
  }

  void downloadFile(String fileName) async {
    try {
      var name = fileName.replaceAll('resources/', '');
      var path = "/storage/emulated/0/Download/$name";
      var file = File(path);
      var res = await get(Uri.parse('${UtilLink.BASE_URL}$fileName'));
      file.writeAsBytes(res.bodyBytes);
      Utils.showSnackBar(title: 'Thông báo', message: 'Tải file thành công !');
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Không tải được file này !');
    }
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
      "image": linkImage,
      "id_group": Get.arguments.id,
      "id_user": await Utils.getStringValueWithKey('id')
    };
    print(linkImage);
    var response = await APICaller.getInstance().post('chat', body);
    if (response != null) {
      textEditingMessage.clear();
      linkImage = '';
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

  postImage() async {
    if (imageFile.isNotEmpty) {
      try {
        var response = await APICaller.getInstance()
            .postFile('image/single', imageFile.first);
        if (response != null) {
          linkImage = response['image'];
        }
      } catch (e) {
        Utils.showSnackBar(title: 'Thông báo', message: 'Lỗi ảnh');
      }
    }
  }

  void getImage(int source) async {
    if (imageFile.isNotEmpty) {
      imageFile.clear();
    }
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Lấy danh sách các tệp đã chọn
      List<File> files = result.paths.map((path) => File(path!)).toList();
      imageFile.addAll(files);
    }

    // List<File> file = await Utils.getImagePicker(source, false);
    // imageFile.addAll(file);
  }

  void clearImage() {
    if (imageFile.isNotEmpty) {
      imageFile.clear();
    }
  }
}
