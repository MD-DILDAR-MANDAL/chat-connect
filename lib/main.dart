import 'package:chat_connect/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat Connect",
      initialRoute: RouteManager.loadingPage,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
