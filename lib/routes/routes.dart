import 'package:chat_connect/pages/loading/done_loading.dart';
import 'package:chat_connect/pages/loading/intro.dart';
import 'package:chat_connect/pages/loading/loading_page.dart';
import 'package:chat_connect/pages/loading/login_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loadingPage = '/';
  static const String loginPage = '/loginPage';
  static const String doneLoading = '/doneLoading';
  static const String introPage = '/introPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loadingPage:
        return MaterialPageRoute(builder: (context) => LoadingPage());
      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case doneLoading:
        return MaterialPageRoute(builder: (context) => DoneLoading());
      case introPage:
        return MaterialPageRoute(builder: (context) => IntroPage());
      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
