import 'package:chat_connect/models/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUser extends StatefulWidget {
  const ChatUser(this.sender, this.receiver, {super.key});
  final String sender;
  final String receiver;
  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    // final queryRef = db.collection("users").doc(widget.receiver);
    // final docref = await queryRef.get();
    // final dataQuery = docref.then((DocumentSnapshot doc) {
    //   final data = doc.data() as Map<String, dynamic>;
    // });
    final name = "username";

    final String chatDocid =
        (widget.sender.compareTo(widget.receiver) < 0)
            ? "${widget.sender}_${widget.receiver}"
            : "${widget.receiver}_${widget.sender}";

    final msgController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: const Color.fromARGB(255, 230, 227, 227),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    db
                        .collection("messages")
                        .doc(chatDocid)
                        .collection("msgDetail")
                        .orderBy("time")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        height: 10,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data = messages[index].data();
                      String formattedTime = "";
                      if (data["time"] != null) {
                        Timestamp timestamp = data["time"] ?? " ";
                        DateTime datetime = timestamp.toDate();
                        formattedTime = datetime.toLocal().toString();
                      }
                      bool isSender = data["fromid"] == widget.sender;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                              isSender
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSender ? primaryColor : tertiaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft:
                                      isSender
                                          ? Radius.circular(12)
                                          : Radius.circular(0),
                                  bottomRight:
                                      isSender
                                          ? Radius.circular(0)
                                          : Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                data["content"],
                                style: TextStyle(
                                  color: isSender ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              child: Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      controller: msgController,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      if (msgController.text.isNotEmpty) {
                        db
                            .collection("messages")
                            .doc(chatDocid)
                            .collection("msgDetail")
                            .add({
                              "content": msgController.text,
                              "fromid": widget.sender,
                              "time": FieldValue.serverTimestamp(),
                              "toid": widget.receiver,
                            });
                        msgController.clear();
                      }
                    },
                    icon: Icon(Icons.send_rounded, size: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
