import 'package:chat_connect/models/themes.dart';
import 'package:chat_connect/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text("E-chat", style: TextStyle(fontStyle: FontStyle.italic)),

        actions: [
          IconButton(
            onPressed: () {
              ConnectUser(context, uid);
            },

            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RouteManager.profilePage,
                arguments: uid,
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('chats').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final contactData = snapshot.data?.data() as Map<String, dynamic>;
          final List contacts = contactData['contacts'] ?? [];
          if (contacts.isEmpty) {
            return Text("add some people");
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contactUid = contacts[index];

              return FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(contactUid)
                        .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(title: Text("loading.........."));
                  }
                  if (!snapshot.data!.exists) {
                    return ListTile(title: Text("loading.........."));
                  }
                  final queryData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  String userName = queryData['user'] ?? contactUid;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: ListTile(
                      title: Text(
                        userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Map<String, dynamic> sendReceive = {
                          "sender": uid,
                          "receiver": contactUid,
                        };

                        Navigator.pushNamed(
                          context,
                          RouteManager.chatUser,
                          arguments: sendReceive,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
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
                    //      final data = doc.data();
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
