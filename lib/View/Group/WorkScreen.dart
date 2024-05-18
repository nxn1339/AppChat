import 'package:chat_app/Controller/WorkController.dart';
import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkScreen extends StatelessWidget {
  WorkScreen({super.key});
  var delete = Get.delete<WorkController>();
  var controller = Get.put(WorkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Công việc'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0.5,
        actions: [
          GestureDetector(
            onTap: () {
              showDialogCreateWork(context, "");
            },
            child: Container(
                padding: EdgeInsets.all(4),
                color: UtilColor.textBase,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: Obx(
        () => Container(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.refreshWork();
            },
            child: Column(
              children: [
                Expanded(
                    child: controller.isLoading.value == true
                        ? Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : controller.listWork.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Chưa có công việc nào',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: UtilColor.textBase,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                        color: UtilColor.buttonBlack,
                                        child: IconButton(
                                          onPressed: () {
                                            showDialogCreateWork(context, "");
                                          },
                                          icon: Icon(Icons.add),
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: controller.listWork.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.selectIndex = index;
                                      Navigation.navigateTo(
                                          page: 'ReportScreen',
                                          arguments:
                                              controller.listWork[index]);
                                    },
                                    onLongPress: () {
                                      _showBottomSheet(
                                          context,
                                          controller.listWork[index].id ?? '',
                                          controller.listWork[index].name ??
                                              '');
                                    },
                                    child: Card(
                                      color: UtilColor.buttonLightBlue,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              controller.listWork[index].name ??
                                                  '',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDialogCreateWork(BuildContext context, String id) {
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
                    hintText: 'Tên công việc...',
                  ),
                  controller: controller.textEditNameWork,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (id == "" || id == null) {
                      controller.addWork();
                    } else {
                      controller.updateWork(id);
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

  void _showBottomSheet(BuildContext context, String id, String name) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Chỉnh sửa'),
                onTap: () {
                  controller.textEditNameWork.text = name;
                  showDialogCreateWork(context, id);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Xóa'),
                onTap: () {
                  controller.deleteWork(id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
