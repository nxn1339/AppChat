import 'package:chat_app/View/Chat/MessageSingle.dart';
import 'package:chat_app/View/Home/HomeScreen.dart';
import 'package:chat_app/View/Authen/LoginScreen.dart';

class RouteDefine {
  static dynamic getPageByName(String pageName) {
    switch (pageName) {
      case 'LoginScreen':
      return LoginScreen();
      case 'HomeScreen':
      return HomeScreen();
      case 'MessageSingle':
      return MessageSingle();
    }
  }
}
