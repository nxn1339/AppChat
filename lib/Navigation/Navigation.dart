import 'package:get/get.dart';
import 'RouteDefine.dart';

class Navigation {
  static String currentPageName = '';
  static dynamic currentParam = null;
  static Future<dynamic>? navigateTo(
      {required String page, dynamic arguments}) {
    currentParam = null;
    if (arguments != null) {
      currentParam = arguments;
    }

    currentPageName = page;
    return Get.to(RouteDefine.getPageByName(page),
        transition: Transition.rightToLeft, arguments: arguments);
  }

  static void goBack({Object? result, dynamic arguments}) {
    currentParam = null;
    currentPageName = "";
    if (arguments != null) {
      currentParam = arguments;
    }
    Get.back(result: result);
  }

  /* ====== delete previous route and routes*/
  static void navigateGetxOff({required String routeName, dynamic? arguments}) {
    Get.offNamed(routeName, arguments: arguments);
  }

  static void navigateGetxOffAll(
      {required String routeName, dynamic? arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }

  static void navigateGetOffAll({required String page, dynamic arguments}) {
    currentParam = null;
    if (arguments != null) {
      currentParam = arguments;
    }
    Get.offAll(RouteDefine.getPageByName(page),
        transition: Transition.rightToLeft, arguments: arguments);
  }
}
