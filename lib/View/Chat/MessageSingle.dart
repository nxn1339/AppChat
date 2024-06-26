import 'package:chat_app/Controller/MessageSingleController.dart';
import 'package:chat_app/Navigation/Navigation.dart';
import 'package:chat_app/Service/SocketIO.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSingle extends StatelessWidget {
  MessageSingle({super.key});
  var controller = Get.put(MessageSingleController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: UtilColor.textBase,
        elevation: 0.5,
        actions: [
          ElevatedButton(
              onPressed: () {
                showDialogSearch(context);
              },
              child: Icon(Icons.search)),
        ],
        title: Obx(
          () => Column(
            children: [
              ClipOval(
                child: Image.network(
                  '${UtilLink.BASE_URL}${controller.user.value.avatar}',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 6),
                        color: UtilColor.buttonBlue,
                        child: Center(
                          child: Text(
                            controller.user.value.name!.isEmpty
                                ? 'A'
                                : controller.user.value.name![0],
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ));
                  },
                ),
              ),
              Text(
                '${controller.user.value.name}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: UtilColor.textBase),
              )
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              flex: controller.isLoading.value == true ? 10 : 1,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    controller.isLoading.value == true
                        ? CircularProgressIndicator()
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 100,
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollControllerLoadMore.value,
                itemCount: controller.messageList.length,
                itemBuilder: (context, index) {
                  if (controller.messageList[index].content != "" ||
                      controller.messageList[index].image != "") {
                    if (controller.uuid.value !=
                        controller.messageList[index].idUser) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    '${UtilLink.BASE_URL}${controller.messageList[index].avatar}',
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.amber,
                                        child: Text('Error'),
                                      );
                                    },
                                  ),
                                ),
                                //trường hợp nhiều lớn hon 40 ký tự responsive
                                controller.messageList[index].content!.length >
                                        40
                                    ? Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            controller.messageList[index]
                                                        .image !=
                                                    ''
                                                ? GestureDetector(
                                                    onTap: () {
                                                      controller.downloadFile(
                                                          controller
                                                                  .messageList[
                                                                      index]
                                                                  .image ??
                                                              '');
                                                    },
                                                    child: controller.isImageLink(
                                                                controller
                                                                    .messageList[
                                                                        index]
                                                                    .image
                                                                    .toString()) !=
                                                            true
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                color: UtilColor
                                                                    .buttonBlack,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        4),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        10),
                                                            child: Text(
                                                                controller.getFileExtension(controller
                                                                    .messageList[
                                                                        index]
                                                                    .image
                                                                    .toString()),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white)),
                                                          )
                                                        : Image.network(
                                                            '${UtilLink.BASE_URL}${controller.messageList[index].image}',
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Container(
                                                                height: 60,
                                                                width: 60,
                                                                color: Colors
                                                                    .amber,
                                                                child: Text(
                                                                    'Error'),
                                                              );
                                                            },
                                                          ),
                                                  )
                                                : Container(),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: UtilColor
                                                        .buttonLightBlue,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                margin: const EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 0,
                                                    left: 3,
                                                    right: 3),
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      controller
                                                              .messageList[
                                                                  index]
                                                              .content ??
                                                          "",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                            Row(
                                              children: [
                                                Text(
                                                  controller
                                                      .messageList[index].name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          UtilColor.textGrey),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  controller
                                                      .convertDateTimeFormat(
                                                          controller
                                                              .messageList[
                                                                  index]
                                                              .time
                                                              .toString()),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          UtilColor.textBase),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    //trường hợp nhỏ hơn 40 ký tự
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          controller.messageList[index].image !=
                                                  ''
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 3, right: 3),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.downloadFile(
                                                          controller
                                                                  .messageList[
                                                                      index]
                                                                  .image ??
                                                              '');
                                                    },
                                                    child: controller.isImageLink(
                                                                controller
                                                                    .messageList[
                                                                        index]
                                                                    .image
                                                                    .toString()) !=
                                                            true
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                color: UtilColor
                                                                    .buttonBlack,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        4),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        10),
                                                            child: Text(
                                                                controller.getFileExtension(controller
                                                                    .messageList[
                                                                        index]
                                                                    .image
                                                                    .toString()),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white)),
                                                          )
                                                        : Image.network(
                                                            '${UtilLink.BASE_URL}${controller.messageList[index].image}',
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Container(
                                                                height: 60,
                                                                width: 60,
                                                                color: Colors
                                                                    .amber,
                                                                child: Text(
                                                                    'Error'),
                                                              );
                                                            },
                                                          ),
                                                  ),
                                                )
                                              : Container(),
                                          Row(
                                            children: [
                                              controller.messageList[index]
                                                      .content!.isNotEmpty
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: UtilColor
                                                              .buttonLightBlue,
                                                          borderRadius: const BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      10))),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 6),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              bottom: 0,
                                                              left: 3,
                                                              right: 3),
                                                      child: Container(
                                                          margin: const EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                          child: Text(
                                                            controller
                                                                    .messageList[
                                                                        index]
                                                                    .content ??
                                                                "",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          )))
                                                  : Container(),
                                              Row(
                                                children: [
                                                  Text(
                                                    controller
                                                        .messageList[index].name
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            UtilColor.textGrey),
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    controller
                                                        .convertDateTimeFormat(
                                                            controller
                                                                .messageList[
                                                                    index]
                                                                .time
                                                                .toString()),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            UtilColor.textBase),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          controller.messageList[index].image != ''
                              ? controller.isImageLink(controller
                                          .messageList[index].image
                                          .toString()) !=
                                      true
                                  ? GestureDetector(
                                      onLongPress: () {
                                        Utils.showDialog(
                                          title: "Xóa tin nhắn",
                                          content: Text(
                                              'Bạn có chắc xóa tin nhắn này?'),
                                          textCancel: 'Thoát',
                                          textConfirm: 'Xóa',
                                          onCancel: () {},
                                          onConfirm: () {
                                            controller.deleteChat(controller
                                                    .messageList[index].id ??
                                                "");
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: UtilColor.buttonBlack,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Text(
                                            controller.getFileExtension(
                                                controller
                                                    .messageList[index].image
                                                    .toString()),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                      ),
                                    )
                                  : GestureDetector(
                                      onLongPress: () {
                                        Utils.showDialog(
                                          title: "Xóa tin nhắn",
                                          content: Text(
                                              'Bạn có chắc xóa tin nhắn này?'),
                                          textCancel: 'Thoát',
                                          textConfirm: 'Xóa',
                                          onCancel: () {},
                                          onConfirm: () {
                                            controller.deleteChat(controller
                                                    .messageList[index].id ??
                                                "");
                                          },
                                        );
                                      },
                                      child: Image.network(
                                        '${UtilLink.BASE_URL}${controller.messageList[index].image}',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 60,
                                            width: 60,
                                            color: Colors.amber,
                                            child: Text('Error'),
                                          );
                                        },
                                      ),
                                    )
                              : Container(),
                          controller.messageList[index].content!.isNotEmpty
                              ? GestureDetector(
                                  onLongPress: () {
                                    Utils.showDialog(
                                      title: "Xóa tin nhắn",
                                      content:
                                          Text('Bạn có chắc xóa tin nhắn này?'),
                                      textCancel: 'Thoát',
                                      textConfirm: 'Xóa',
                                      onCancel: () {},
                                      onConfirm: () {
                                        controller.deleteChat(
                                            controller.messageList[index].id ??
                                                "");
                                      },
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: UtilColor.buttonBlue,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        margin: const EdgeInsets.only(
                                            left: 3, right: 3),
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              controller.messageList[index]
                                                      .content ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ))),
                                  ),
                                )
                              : Container()
                        ],
                      );
                    }
                  }
                  return Container();
                },
              ),
            ),
          ),
          Obx(
            () => Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: Utils.textFieldCustom(
                            icon: GestureDetector(
                                onTap: () {
                                  showBottomSheet(context);
                                },
                                child: Icon(Icons.file_present)),
                            controller: controller.textEditingMessage,
                            hintText: "Nhắn tin",
                            maxLines: 1),
                      )),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          await controller.postImage();
                          await sendMessage(
                              controller.textEditingMessage.text,
                              controller.group.value.id.toString(),
                              controller.linkImage);
                          controller.clearImage();

                          controller.scrollChat();
                        },
                      ),
                    ],
                  ),
                ),
                controller.imageFile.isNotEmpty
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 80,
                          width: 80,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                controller.imageFile.first,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: UtilColor.buttonLightBlue,
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black)),
                                    height: 80,
                                    width: 80,
                                    child:
                                        const Center(child: Text('File mới')),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.clearImage();
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  color: UtilColor.buttonRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  showDialogSearch(BuildContext context) {
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
                    hintText: 'Tìm tin nhắn...',
                  ),
                  controller: controller.textEditingSearch,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    controller.createStart();
                    Get.back();
                  },
                  child: Text('Tìm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Thư mục'),
                onTap: () {
                  controller.getImage(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
                  controller.getImage(1);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  sendMessage(String content, String idGroup, String image) async {
    var idUser = await Utils.getStringValueWithKey('id');
    var avatar = await Utils.getStringValueWithKey('avatar');
    var name = await Utils.getStringValueWithKey('name');
    if (content.isNotEmpty || image.isNotEmpty) {
      SocketIOCaller.getInstance().socket?.emit('messageSingle', {
        'id_user': idUser,
        'time': DateTime.now().toIso8601String(),
        'content': content,
        'avatar': avatar,
        'image': image,
        'name': name,
        'id_group': idGroup,
      });

      SocketIOCaller.getInstance().socket?.emit('readMessage', {
        'id_group': idGroup,
        'id_user': idUser,
        'read_message': 1,
      });
    }
  }
}
