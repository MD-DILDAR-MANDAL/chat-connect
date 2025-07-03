import 'package:chat_connect/models/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList(this.id, {super.key});
  final String id;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    final String uid = widget.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tertiaryColor,
        foregroundColor: primaryColor,
        title: Text("E-chat", style: TextStyle(color: primaryColor)),

        actions: [
          IconButton(
            onPressed: () {
              ConnectUser(context, uid);
            },

            icon: Icon(Icons.add, color: primaryColor),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: primaryColor),
          ),
        ],
      ),
      body: ListView(),
    );
  }

  Future<dynamic> ConnectUser(BuildContext context, String uid) {
    final emailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text("enter email to connect with others"),
            content: TextField(controller: emailController, autofocus: true),
            actions: [
              TextButton(
                onPressed: () async {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  final userRef = db.collection("users");
                  final querySnapshot =
                      await userRef
                          .where("email", isEqualTo: emailController.text)
                          .get();

                  final String ruid;

                  if (querySnapshot.docs.isNotEmpty) {
                    final doc = querySnapshot.docs.first;
                    final data = doc.data();
                    ruid = doc.id;

                    final chatRef = db.collection("chats").doc(uid);
                    final chatSnapshots = await chatRef.get();

                    if (!chatSnapshots.exists) {
                      await chatRef.set({"contacts": []});
                    }
                    db.collection("chats").doc(uid).update({
                      "contacts": FieldValue.arrayUnion([ruid]),
                    });

                    final rchatRef = db.collection("chats").doc(ruid);
                    final rchatSnapshots = await rchatRef.get();

                    if (!rchatSnapshots.exists) {
                      await rchatRef.set({"contacts": []});
                    }
                    await db.collection("chats").doc(ruid).update({
                      "contacts": FieldValue.arrayUnion([uid]),
                    });
                  } else {
                    print('no doc found');
                  }

                  Navigator.pop(context);
                },
                child: Text('add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}
