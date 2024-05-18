import 'package:chat_app/View/Authen/ChangePassword.dart';
import 'package:chat_app/View/Authen/RegisterScreen.dart';
import 'package:chat_app/View/Chat/AddMemberGroup.dart';
import 'package:chat_app/View/Chat/MessageGroup.dart';
import 'package:chat_app/View/Chat/MessageGroupDetail.dart';
import 'package:chat_app/View/Chat/MessageSingle.dart';
import 'package:chat_app/View/Group/CreateGroup.dart';
import 'package:chat_app/View/Group/ReportScreen.dart';
import 'package:chat_app/View/Group/WorkScreen.dart';
import 'package:chat_app/View/Home/HomeScreen.dart';
import 'package:chat_app/View/Authen/LoginScreen.dart';
import 'package:chat_app/View/Home/SearchUser.dart';
import 'package:chat_app/View/Profile/ProfileScreen.dart';

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
      case 'MessageSingle':
        return MessageSingle();
      case 'ProfileScreen':
        return ProfileScreen();
      case 'ChangePassword':
        return ChangePassword();
      case 'RegisterScreen':
        return RegisterScreen();
      case 'SearchUser':
        return SearchUser();
      case 'WorkScreen':
        return WorkScreen();
      case 'ReportScreen':
        return ReportScreen();
    }
  }
}
