import 'package:chat_app/View/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  List<Group> listGroup = [
    new Group(
        nameGroup: 'Oke men',
        nameUser: 'Ngát',
        content: 'ít thì 5 quả trứng',
        image:
            'https://likevape.vn/wp-content/uploads/2023/08/21205817-hinh-anh-gai-xinh-11.jpg'),
    new Group(
        nameGroup: 'Không oke',
        nameUser: 'Em Ngát',
        image:
            'https://vsmall.vn/wp-content/uploads/2022/06/hinh-anh-con-gai-cute-de-thuong-cute-anime-hoat-hinh-xinh-48.jpg'),
    new Group(nameGroup: 'Gần OKE', nameUser: 'Dấu tên'),
    new Group(nameGroup: 'Ngát', nameUser: 'Ko biết tên'),
    new Group(nameGroup: 'Test Nhóm', nameUser: 'Ngát'),
    new Group(nameGroup: 'Siuuuuuu', nameUser: 'Siu'),
  ];
}

class Group {
  String? nameGroup;
  String? nameUser;
  String? content;
  String? image;
  Group({this.nameGroup, this.nameUser, this.content, this.image});
}
