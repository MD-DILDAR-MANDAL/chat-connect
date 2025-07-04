import 'package:chat_connect/pages/chat/chat_list.dart';
import 'package:chat_connect/pages/chat/chat_user.dart';
import 'package:flutter/material.dart';

import 'package:chat_connect/pages/authentication/login_page.dart';
import 'package:chat_connect/pages/authentication/register_page.dart';
import 'package:chat_connect/pages/loading/done_loading.dart';
import 'package:chat_connect/pages/loading/intro_page.dart';
import 'package:chat_connect/pages/loading/loading_page.dart';
import 'package:chat_connect/pages/profile/edit_page.dart';
import 'package:chat_connect/pages/profile/profile_page.dart';

class RouteManager {
  static const String loadingPage = '/';
  static const String loginPage = '/loginPage';
  static const String doneLoading = '/doneLoading';
  static const String introPage = '/introPage';
  static const String registerPage = '/registerPage';
  static const String profilePage = '/profilePage';
  static const String editPage = '/editPage';
  static const String chatList = '/chatList';
  static const String chatUser = '/chatUser';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var data;

    if (settings.arguments != null) {
      data = settings.arguments;
    }

    switch (settings.name) {
      case loadingPage:
        return MaterialPageRoute(builder: (context) => LoadingPage());

      case doneLoading:
        return MaterialPageRoute(builder: (context) => DoneLoading());

      case introPage:
        return MaterialPageRoute(builder: (context) => IntroPage());

      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());

      case registerPage:
        return MaterialPageRoute(builder: (context) => RegisterPage());

      case profilePage:
        return MaterialPageRoute(builder: (context) => ProfilePage(data));

      case editPage:
        return MaterialPageRoute(builder: (context) => EditPage());

      case chatList:
        return MaterialPageRoute(builder: (context) => ChatList(data.uid));

      case chatUser:
        return MaterialPageRoute(
          builder: (context) => ChatUser(data["sender"], data["receiver"]),
        );

      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
