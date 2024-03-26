import 'package:chat_app/View/LoginScreen.dart';

class RouteDefine {
  static dynamic getPageByName(String pageName) {
    switch (pageName) {
      case 'LoginScreen':
      return LoginScreen();
    }
  }
}
