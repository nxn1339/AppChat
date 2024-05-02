import 'package:chat_app/View/Chat/AddMemberGroup.dart';
import 'package:chat_app/View/Chat/MessageGroup.dart';
import 'package:chat_app/View/Chat/MessageGroupDetail.dart';
import 'package:chat_app/View/Group/CreateGroup.dart';
import 'package:chat_app/View/Home/HomeScreen.dart';
import 'package:chat_app/View/Authen/LoginScreen.dart';

class RouteDefine {
  static dynamic getPageByName(String pageName) {
    switch (pageName) {
      case 'LoginScreen':
        return LoginScreen();
      case 'HomeScreen':
        return HomeScreen();
      case 'MessageGroup':
        return MessageGroup();
      case 'CreateGroup':
        return CreateGroup();
      case 'MessageGroupDetail':
        return MessageGroupDetail();
      case 'AddMemberGroup':
        return AddMemberGroup();
    }
  }
}
