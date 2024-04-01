import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //type 0 là group 1 là single
 RxList<Group>  listGroup = [
    new Group(
        nameGroup: 'Oke men',
        nameUser: 'Ngát',
        content: 'ít thì 5 quả trứng',
        image:
            'https://likevape.vn/wp-content/uploads/2023/08/21205817-hinh-anh-gai-xinh-11.jpg',
        type: 1),
    new Group(
        nameGroup: 'Không oke',
        nameUser: 'Em Ngát',
        image:
            'https://vsmall.vn/wp-content/uploads/2022/06/hinh-anh-con-gai-cute-de-thuong-cute-anime-hoat-hinh-xinh-48.jpg',
        type: 0),
    new Group(
        nameGroup: 'Test Nhóm tập 1',
        nameUser: 'Dấu tên',
        type: 0,
        image: 'https://zshop.vn/blogs/wp-content/uploads/2016/08/1045.jpg'),
    new Group(
        nameGroup: 'Nhóm này',
        nameUser: 'Ko biết tên',
        type: 0,
        image:
            'https://noithatbinhminh.com.vn/wp-content/uploads/2022/08/anh-dep-40.jpg.webp'),
    new Group(nameGroup: 'Test Nhóm', nameUser: 'Ngát', type: 0),
    new Group(nameGroup: 'Siuuuuuu', nameUser: 'Siu', type: 1),
  ].obs;
}

class Group {
  String? nameGroup;
  String? nameUser;
  String? content;
  String? image;
  int? type;
  Group({this.nameGroup, this.nameUser, this.content, this.image, this.type});
}
