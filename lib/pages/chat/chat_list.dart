import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-chat", style: TextStyle()),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: ListView(),
    );
  }
}
