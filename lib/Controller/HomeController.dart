import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/Model/MDGroup.dart';
import 'package:chat_app/Model/MDMember.dart';
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
  RxList<MDMember> listStatusMessage = RxList<MDMember>();
  MDMember memberNew = new MDMember();
  MDMessage messageNew = new MDMessage();
  bool isLoadingGroup = false;
  bool isLoadingStatus = false;
  bool isLoadingLastChat = false;
  RxBool isLoading = true.obs;
  RxString avatar = ''.obs;
  RxString name = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadSavedText();
    await fecthGroup();
    await fecthLastChat();
    await fecthStatusMessage();
    await checkLoading();

    SocketIOCaller.getInstance().socket?.on('chat message', (data) {
      messageNew = MDMessage.fromJson(data);
      print(messageNew.content);
      for (int i = 0; i < messageList.length; i++) {
        if (messageList[i].idGroup == messageNew.idGroup) {
          messageList[i] = messageNew;
          messageList.refresh();
        }
      }
    });

    SocketIOCaller.getInstance().socket?.on('readMessage', (data) {
      if (listStatusMessage.isNotEmpty) {
        memberNew = MDMember.fromJson(data);
        if (memberNew.readMessage == 1) {
          for (int i = 0; i < listStatusMessage.length; i++) {
            if (listStatusMessage[i].idGroup == memberNew.idGroup &&
                listStatusMessage[i].idUser != memberNew.idUser) {
              listStatusMessage[i].readMessage = memberNew.readMessage;
              listStatusMessage.refresh();
              String content = '';
              if (messageNew.content!.isEmpty) {
                content = 'Ảnh mới';
              } else {
                content = messageNew.content.toString();
              }
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                id: 1,
                channelKey: 'Key',
                title: '${messageNew.name} Đã gửi tin nhắn mới',
                body: content,
              ));
            }
          }
        } else {
          for (int i = 0; i < listStatusMessage.length; i++) {
            if (listStatusMessage[i].idGroup == memberNew.idGroup &&
                listStatusMessage[i].idUser == memberNew.idUser) {
              listStatusMessage[i].readMessage = memberNew.readMessage;
              listStatusMessage.refresh();
            }
          }
        }
      } else {
        listStatusMessage.add(MDMember.fromJson(data));
      }
    });
  }

  loadSavedText() async {
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      uuid = await Utils.getStringValueWithKey('id');
    }
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      avatar.value = await Utils.getStringValueWithKey('avatar');
    }
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      name.value = await Utils.getStringValueWithKey('name');
    }
  }

  checkLoading() {
    isLoading.value = true;
    if (isLoadingGroup == false &&
        isLoadingLastChat == false &&
        isLoadingStatus == false) {
      isLoading.value = false;
    }
  }

  fecthStatusMessage() async {
    isLoadingStatus = true;
    try {
      for (var i = 0; i < listGroup.length; i++) {
        var response =
            await APICaller.getInstance().get('group/$uuid/${listGroup[i].id}');
        if (response != null) {
          print(response);
          List<dynamic> list = response['data'];
          var listItem =
              list.map((dynamic json) => MDMember.fromJson(json)).toList();
          listStatusMessage.addAll(listItem);
          listStatusMessage.refresh();
          isLoadingStatus = false;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  fecthGroup() async {
    isLoadingGroup = true;
    try {
      var response = await APICaller.getInstance().get('group/$uuid');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDGroup.fromJson(json)).toList();
        listGroup.addAll(listItem);
        listGroup.refresh();
        isLoadingGroup = false;
      }
    } catch (e) {
      print(e);
    }
  }

  fecthLastChat() async {
    isLoadingLastChat = true;
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
          isLoadingLastChat = false;
        }
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void updateStatus(String idGroup) async {
    var body = {"id_group": idGroup, "id_user": uuid};
    try {
      var response = await APICaller.getInstance().put('group', body);
      if (response != null) {
        SocketIOCaller.getInstance().socket?.emit('readMessage', {
          'id_group': idGroup,
          'id_user': uuid,
          'read_message': 0,
        });
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
    isLoading.value = true;
    if (listGroup.isNotEmpty) {
      listGroup.clear();
    }
    await fecthGroup();
    if (messageList.isNotEmpty) {
      messageList.clear();
    }
    await fecthLastChat();
    if (listStatusMessage.isNotEmpty) {
      listStatusMessage.clear();
    }
    await fecthStatusMessage();

    await checkLoading();
  }
}
