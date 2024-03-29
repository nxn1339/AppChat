import 'package:get/get.dart';

class HomeController extends GetxController{
  List<Group> listGroup = [
    new Group(nameGroup: 'Oke men',nameUser: 'Ngát',content: 'ít thì 5 quả trứng'),
    new Group(nameGroup: 'Không oke',nameUser: 'Em Ngát'),
    new Group(nameGroup: 'Gần OKE',nameUser: 'Dấu tên'),
    new Group(nameGroup: 'Ngát',nameUser: 'Ko biết tên'),
    new Group(nameGroup: 'Test Nhóm',nameUser: 'Ngát'),
    new Group(nameGroup: 'Siuuuuuu',nameUser: 'Siu'),
  ];

}
class Group{
  String ?nameGroup;
  String ?nameUser;
  String ?content;
  Group({this.nameGroup,this.nameUser,this.content});
}