import 'package:chat_connect/models/themes.dart';
import 'package:chat_connect/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: IntroductionScreen(
        key: _introKey,
        dotsDecorator: DotsDecorator(
          activeColor: primaryColor,
          activeSize: Size(15, 15),
        ),
        next: Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.black,
          size: 30,
        ),
        done: Text('done'),
        onDone:
            () => Navigator.popAndPushNamed(context, RouteManager.loginPage),
        globalBackgroundColor: Colors.white,
        pages: [
          pageViewgenerate('Reliable and Fast Text based chatting', "chat.png"),
          pageViewgenerate(
            'Ensure Privacy with encrypted messages',
            "security.png",
          ),
          pageViewgenerate(
            'Cross Platform compatibility',
            "cross_platform.png",
          ),
        ],
        showNextButton: true,
        showDoneButton: true,
      ),
    );
  }

  PageViewModel pageViewgenerate(String ttitle, String img) {
    return PageViewModel(
      titleWidget: Text(
        ttitle,
        textAlign: TextAlign.center,
        style: TextStyle(color: primaryColor, fontSize: 32),
      ),
      body: '',
      image: Image.asset("assets/intro/$img"),
      decoration: PageDecoration(
        imageFlex: 2,
        bodyFlex: 1,
        bodyPadding: EdgeInsets.zero,
        imagePadding: EdgeInsets.all(10),
      ),
    );
  }
}
