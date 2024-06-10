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
  Rx<MDGroup> group = new MDGroup().obs;
  RxList<File> imageFile = RxList<File>();
  String linkImage = '';
  Rx<ScrollController> scrollControllerLoadMore = new ScrollController().obs;
  int page = 1;
  int total = 0;
  RxBool isLoading = false.obs;
  String idChat = "";

  @override
  void onInit() async {
    super.onInit();
    createStart();
    scrollControllerLoadMore.value.addListener(() {
      if (scrollControllerLoadMore.value.position.pixels <=
          scrollControllerLoadMore.value.position.minScrollExtent) {
        isLoading.value = true;
        if (total > messageList.length) {
          page++;
          fechListChatLoadMore();
        } else {
          isLoading.value = false;
        }
      }
    });
    SocketIOCaller.getInstance().socket?.on('messageGroup', (data) {
      sendChat();
      messageList.add(MDMessage.fromJson(data));
      messageList.last.id = idChat;
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
    page = 1;
    isLoading.value = false;
    if (messageList.isNotEmpty) {
      messageList.clear();
    }
    uuid.value = await Utils.getStringValueWithKey('id');
    group.value = await Get.arguments;
    fechListChat();
    scrollChat();
  }

  void fechListChat() async {
    isLoading.value = true;
    try {
      var response = await APICaller.getInstance()
          .get('chat/${Get.arguments.id}?page=$page');
      if (response != null) {
        total = response['meta']['total'];
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDMessage.fromJson(json)).toList();

        messageList.addAll(listItem.reversed);
        messageList.refresh();
        isLoading.value = false;
      }
    } catch (e) {}
  }

  void fechListChatLoadMore() async {
    try {
      var response = await APICaller.getInstance()
          .get('chat/${Get.arguments.id}?page=$page');
      if (response != null) {
        total = response['meta']['total'];
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDMessage.fromJson(json)).toList();

        messageList.insertAll(0, listItem.reversed);
        messageList.refresh();
        isLoading.value = false;
      }
    } catch (e) {}
  }

  sendChat() async {
    var body = {
      "content": textEditingMessage.text,
      "image": linkImage,
      "id_group": Get.arguments.id,
      "id_user": await Utils.getStringValueWithKey('id')
    };
    var response = await APICaller.getInstance().post('chat', body);
    if (response != null) {
      Map<String, dynamic> json = response['data'][0];
      MDMessage mdMessage = MDMessage.fromJson(json);
      idChat = mdMessage.id.toString();

      textEditingMessage.clear();
      linkImage = '';
    }
  }

  deleteChat(String id) async {
    var response = await APICaller.getInstance().delete('chat/delete/$id');
    if (response != null) {
      messageList.where((x) => x.id == id).first.content = "Đã xóa tin này";
      messageList.where((x) => x.id == id).first.image = "";
      messageList.refresh();
      Get.back();
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
    if (scrollControllerLoadMore == null) {
      return;
    }
    scrollControllerLoadMore.value.animateTo(
      (scrollControllerLoadMore.value.position.maxScrollExtent * 3),
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
    if (source == 0) {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        // Lấy danh sách các tệp đã chọn
        List<File> files = result.paths.map((path) => File(path!)).toList();
        imageFile.addAll(files);
      }
    } else {
      List<File> file = await Utils.getImagePicker(source, false);
      imageFile.addAll(file);
    }
    Get.back();
  }

  void clearImage() {
    if (imageFile.isNotEmpty) {
      imageFile.clear();
    }
  }

  refreshData() {
    page = 1;
    messageList.clear();
    fechListChat();
  }
}
