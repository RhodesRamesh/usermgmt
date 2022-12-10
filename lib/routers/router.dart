import 'package:get/get.dart';
import 'package:user_management/screens/login/loginPage.dart';
import 'package:user_management/screens/splashscreen/splashscreen.dart';
import 'package:user_management/screens/users/addUser.dart';
import 'package:user_management/screens/users/userList.dart';

class GetPageRouter {
  static String splashScreenRoute = "/";
  static String userListRoute = "/userList";
  static String userAddRoute = "/userAdd";
  static String loginPageRoute = "/loginPage";
  static final routes = [
    GetPage(name: splashScreenRoute, page: () => const SplashScreen()),
    GetPage(name: userListRoute, page: () => const UserList()),
    GetPage(name: userAddRoute, page: () => const UserAdd()),
    GetPage(name: loginPageRoute, page: () => const LoginPage()),
  ];
}
