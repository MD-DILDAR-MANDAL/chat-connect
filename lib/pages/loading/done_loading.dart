import "package:chat_connect/models/themes.dart";
import "package:chat_connect/routes/routes.dart";
import "package:flutter/material.dart";

class DoneLoading extends StatefulWidget {
  const DoneLoading({super.key});
  @override
  State<DoneLoading> createState() {
    return _DoneLoadingState();
  }
}

class _DoneLoadingState extends State<DoneLoading> {
  startTimer() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.popAndPushNamed(context, RouteManager.introPage);
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("assets/loading/logo_3.png", height: 60),
              ),
              Text(
                "Chat Connect",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset("assets/loading/chat_round.png"),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: Text(
                    "Stay Connected \nStay Chatting",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            "version 1.0.0",
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
