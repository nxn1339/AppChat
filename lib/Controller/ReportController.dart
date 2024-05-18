import 'package:chat_app/Controller/WorkController.dart';
import 'package:chat_app/Model/MDReport.dart';
import 'package:chat_app/Model/MDWork.dart';
import 'package:chat_app/Service/APICaller.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  RxList<MDReport> listReport = RxList<MDReport>();
  RxBool isLoading = false.obs;
  Rx<MDWork> work = new MDWork().obs;
  TextEditingController textEditNameReport = TextEditingController();
  TextEditingController textEditTimeWork = TextEditingController();
  RxDouble percent = 0.0.obs;
  String uuid = '';
  String name = '';

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (Get.isRegistered<WorkController>()) {
      var controller = Get.find<WorkController>();
      work.value = controller.listWork[controller.selectIndex];
    }
    loadSavedText();
    fechListReport();
  }

  loadSavedText() async {
    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      uuid = await Utils.getStringValueWithKey('id');
    }

    if (await Utils.getStringValueWithKey('id') != '' ||
        await Utils.getStringValueWithKey('id') != null) {
      name = await Utils.getStringValueWithKey('name');
    }
  }

  void fechListReport() async {
    isLoading.value = true;
    try {
      var response =
          await APICaller.getInstance().get('work/Report/${work.value.id}');
      if (response != null) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => MDReport.fromJson(json)).toList();
        listReport.addAll(listItem);
        listReport.refresh();
        isLoading.value = false;
      }
    } catch (e) {
      print(e);
    }
  }

  void updateReport(String id) async {
    var body = {
      "name": textEditNameReport.text,
      "percent": percent / 100,
      "work_time": textEditTimeWork.text,
      "id": id
    };
    try {
      var response = await APICaller.getInstance().put('work/Report', body);
      if (response != null) {
        Get.back();
        refreshReport();
      }
    } catch (e) {
      print(e);
    }
  }

  void addReport() async {
    var body = {
      "name": textEditNameReport.text,
      "percent": percent / 100,
      "work_time": textEditTimeWork.text,
      "id_work": work.value.id,
      "name_user": name,
      "id_user": uuid
    };
    try {
      var response = await APICaller.getInstance().post('work/Report', body);
      if (response != null) {
        Get.back();
        refreshReport();
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteReport(String id) async {
    try {
      var response = await APICaller.getInstance().delete('work/Report/$id');
      if (response != null) {
        Get.back();
        refreshReport();
      }
    } catch (e) {
      print(e);
    }
  }

  void setUpdate(int index) {
    textEditNameReport.text = listReport[index].name ?? '';
    percent.value = double.parse(listReport[index].percent.toString()) * 100;
    textEditTimeWork.text = listReport[index].workTime.toString();
  }

  void reset() {
    textEditNameReport.text = '';
    percent.value = 0;
    textEditTimeWork.text = '';
  }

  void refreshReport() {
    isLoading.value = true;
    if (listReport.isNotEmpty) {
      listReport.clear();
    }
    fechListReport();
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
}
