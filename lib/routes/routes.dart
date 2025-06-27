import 'package:chat_connect/pages/loading_page.dart';
import 'package:chat_connect/pages/login_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loadingPage = '/';
  static const String loginPage = '/loginPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loadingPage:
        return MaterialPageRoute(builder: (context) => LoadingPage());
      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
