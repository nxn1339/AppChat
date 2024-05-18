import 'package:chat_app/Controller/ReportController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});
  var delete = Get.delete<ReportController>();
  var controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments.name),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0.5,
        actions: [
          GestureDetector(
            onTap: () {
              controller.reset();
              showDialogReport(context, "");
            },
            child: Container(
                padding: EdgeInsets.all(4),
                color: UtilColor.textBase,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(
                  Icons.add_chart,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: Obx(
        () => Container(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.refreshReport();
            },
            child: Column(
              children: [
                Expanded(
                  child: controller.isLoading.value == true
                      ? Center(child: CircularProgressIndicator())
                      : controller.listReport.isEmpty
                          ? Utils.noData()
                          : ListView.builder(
                              itemCount: controller.listReport.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.setUpdate(index);
                                    showDialogReport(context,
                                        controller.listReport[index].id ?? '');
                                  },
                                  onLongPress: () {
                                    Utils.showDialog(
                                        title: 'Xóa báo cáo',
                                        content: Text(
                                            'Bạn có muốn xóa báo cáo này không ?'),
                                        onCancel: () {},
                                        onConfirm: () {
                                          controller.deleteReport(
                                              controller.listReport[index].id ??
                                                  '');
                                        },
                                        textCancel: 'Đóng',
                                        textConfirm: 'Ok');
                                  },
                                  child: Card(
                                    color: UtilColor.buttonLightBlue,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Công viêc: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              controller
                                                      .listReport[index].name ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Tiến độ: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              '${NumberFormat.percentPattern().format(controller.listReport[index].percent)}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Thời gian làm: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              controller.listReport[index]
                                                      .workTime
                                                      .toString() +
                                                  ' giờ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Người làm: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              controller
                                                  .listReport[index].nameUser
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Thời gian báo cáo: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              controller.convertDateTimeFormat(
                                                  controller.listReport[index]
                                                      .updateAt
                                                      .toString()),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              },
                            ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDialogReport(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Công việc...',
                  ),
                  controller: controller.textEditNameReport,
                ),
                Obx(
                  () => Row(
                    children: [
                      Text('Tiến độ'),
                      Slider(
                        value: controller.percent.value,
                        label:
                            controller.percent.value.round().toString() + '%',
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (double value) {
                          controller.percent.value = value;
                        },
                      ),
                    ],
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Thời gian làm',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: controller.textEditTimeWork,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (id == "" || id == null) {
                      controller.addReport();
                    } else {
                      controller.updateReport(id);
                    }
                  },
                  child: Text('Gửi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
