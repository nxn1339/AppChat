import 'package:chat_app/Controller/ProfileController.dart';
import 'package:chat_app/Utils/UtilColor.dart';
import 'package:chat_app/Utils/UtilLink.dart';
import 'package:chat_app/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  var delete = Get.delete<ProfileController>();
  var controller = Get.put(ProfileController());
  Size size = Size(0, 0);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('Cá nhân'),
          backgroundColor: Colors.white,
          foregroundColor: UtilColor.buttonBlack,
          elevation: 0.5),
      body: Obx(
        () => Container(
          width: size.width,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      controller.imageFile.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Image.file(
                                controller.imageFile.first,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                      height: 80,
                                      width: 80,
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
                            )
                          : ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Image.network(
                                '${UtilLink.BASE_URL}${controller.user.value.avatar}',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                      height: 80,
                                      width: 80,
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
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.getImage(0);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: UtilColor.buttonBlack,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('Chọn ảnh',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Tên',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Utils.textFieldCustom(
                          icon: Icon(Icons.person),
                          hintText: 'Tên',
                          controller: controller.textEditName),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Giới tính',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Obx(
                        () => Row(
                          children: [
                            radioButton('Nam', 1),
                            radioButton('Nữ', 2),
                            radioButton('Khác', 3),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Ngày sinh',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.selectDate(context);
                        },
                        child: Utils.textFieldCustom(
                            icon: Icon(Icons.calendar_month),
                            hintText: 'Ngày sinh',
                            controller: controller.textEditBirthDay,
                            enabled: false),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Số điện thoại',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Utils.textFieldCustom(
                          icon: Icon(Icons.phone),
                          hintText: 'Số điện thoại',
                          controller: controller.textEditPhone),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Gmail',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Utils.textFieldCustom(
                          icon: Icon(Icons.mail),
                          hintText: 'Gmail',
                          controller: controller.textEditEmail,
                          enabled: false),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Utils.showDialog(
                    title: 'Thông tin cá nhân',
                    content: Text('Bạn có chắc muốn thay đổi'),
                    textCancel: 'Hủy',
                    textConfirm: 'Đồng ý',
                    onConfirm: () {
                      controller.updateProfile();
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: UtilColor.buttonBlack,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  width: size.width,
                  child: Text(
                    'Lưu lại',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget radioButton(String title, int value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: controller.idGender.value,
          onChanged: (value) {
            controller.setGender(value!);
          },
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
