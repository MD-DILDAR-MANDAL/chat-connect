import 'dart:async';

import 'package:chat_connect/routes/routes.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final List<String> _images = [
    "assets/loading/logo_1.png",
    "assets/loading/logo_2.png",
    "assets/loading/logo_3.png",
  ];
  int _currentIndex = 0;
  Timer? _timer;
  var counter = 6;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
        counter--;
        if (counter == 0) {
          _timer?.cancel();
          Navigator.popAndPushNamed(context, RouteManager.doneLoading);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(_images[_currentIndex], width: 200, height: 200),
      ),
    );
  }
}
