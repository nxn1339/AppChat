import 'dart:io';

import 'package:chat_app/Utils/UtilColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future saveStringWithKey(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future saveIntWithKey(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(key, value);
  }

  static Future getStringValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future getIntValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static void showSnackBar(
      {required String title,
      required String message,
      Color? colorText = Colors.white,
      Widget? icon,
      bool isDismissible = true,
      Duration duration = const Duration(seconds: 2),
      Duration animationDuration = const Duration(seconds: 1),
      Color? backgroundColor = Colors.black,
      SnackPosition? direction = SnackPosition.TOP,
      Curve? animation}) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor!.withOpacity(0.3),
      snackPosition: direction,
      forwardAnimationCurve: animation,
    );
  }

  static void showDialog(
      {required String title,
      TextStyle? titleStyle,
      Widget? content,
      String? textCancel,
      String? textConfirm,
      Color? backgroundColor,
      Color? cancelTextColor,
      Color? confirmTextColor,
      Color? buttonColor,
      Widget? customCancel,
      Widget? customConfirm,
      VoidCallback? onCancel,
      VoidCallback? onConfirm,
      double radius = 10.0}) {
    Get.defaultDialog(
        title: title,
        titleStyle: titleStyle,
        content: content,
        textCancel: textCancel,
        textConfirm: textConfirm,
        backgroundColor: backgroundColor,
        cancel: customCancel,
        confirm: customConfirm,
        onCancel: onCancel,
        onConfirm: onConfirm,
        cancelTextColor: cancelTextColor,
        confirmTextColor: confirmTextColor,
        buttonColor: buttonColor,
        radius: radius);
  }

  static Widget textField(
      {required Widget icon,
      TextEditingController? controller,
      String? hintText,
      TextInputType? textInputType,
      List<TextInputFormatter>? inputFormatters,
      int? maxLines,
      ValueChanged? onChanged,
      bool? enabled,
      TextStyle? style}) {
    return Column(
      children: [
        Row(children: [
          icon,
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: TextField(
              style: style,
              enabled: enabled,
              onChanged: onChanged,
              controller: controller,
              maxLines: maxLines,
              keyboardType: textInputType,
              inputFormatters: inputFormatters,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: hintText),
            ),
          ),
        ]),
        Container(
          height: 1,
          color: Color.fromRGBO(221, 225, 231, 1),
        )
      ],
    );
  }

  static Widget textFieldMuti(
      {required Widget icon,
      TextEditingController? controller,
      String? hintText,
      TextInputType? textInputType,
      List<TextInputFormatter>? inputFormatters,
      int? maxLines,
      ValueChanged? onChanged}) {
    return Column(
      children: [
        Row(children: [
          icon,
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              maxLines: 5,
              keyboardType: textInputType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: hintText),
            ),
          ),
        ]),
      ],
    );
  }

  static Widget textFieldPass(
      {required Widget icon,
      ValueChanged? changed,
      TextEditingController? controller,
      bool? obscureText,
      String? hintText,
      VoidCallback? onTap}) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: TextField(
            onChanged: changed,
            controller: controller,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
            obscureText: obscureText!,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: obscureText
              ? SvgPicture.asset(
                  'assets/icons/hide_eye.svg',
                  height: 20,
                  width: 20,
                  color: Colors.black,
                )
              : SvgPicture.asset(
                  'assets/icons/show_eye.svg',
                  height: 20,
                  width: 20,
                  color: Colors.black,
                ),
        ),
      ],
    );
  }

  static Widget noData() {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: 300,
          width: 250,
          child: SvgPicture.asset(
            'assets/images/not_data.svg',
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'Không có dữ liệu vui lòng thử lại sau !',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    ));
  }

  static Future<List<File>> getImagePicker(int source, bool multiImage) async {
    ImagePicker _picker = ImagePicker();
    List<File> files = List.empty(growable: true);
    try {
      if (multiImage) {
        List<XFile> lst = await _picker.pickMultiImage();
        for (var file in lst) {
          files.add(File(file.path));
        }
      } else {
        await _picker
            .pickImage(
          source: source == 1 ? ImageSource.camera : ImageSource.gallery,
        )
            .then((value) {
          if (value != null) {
            files.add(File(value.path));
          }
        });
      }
    } catch (e) {
      print(e);
    }
    return files;
  }

  static Widget buttonBlack(BuildContext context, String content) {
    return Container(
      decoration: BoxDecoration(
          color: UtilColor.buttonBlack,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
