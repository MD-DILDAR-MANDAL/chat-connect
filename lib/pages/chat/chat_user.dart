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
  final db = FirebaseFirestore.instance;

  var name = "--------";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final doc = await db.collection("users").doc(widget.receiver).get();
    final data = doc.data() as Map<String, dynamic>;
    setState(() {
      name = data["user"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final String chatDocid =
        (widget.sender.compareTo(widget.receiver) < 0)
            ? "${widget.sender}_${widget.receiver}"
            : "${widget.receiver}_${widget.sender}";

    final msgController = TextEditingController();
    final scrollController = ScrollController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: greyLight,
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      scrollController.jumpTo(
                        scrollController.position.maxScrollExtent,
                      );
                    });

                    return ListView.builder(
                      controller: scrollController,
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
                                  color:
                                      isSender ? primaryColor : tertiaryColor,
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
                                    color:
                                        isSender ? Colors.white : Colors.black,
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

              SizedBox(height: 6),

              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 0, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: 2,
                          autocorrect: true,
                          controller: msgController,
                          decoration: InputDecoration(
                            hintText: "Type your message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        color: primaryColor,
                        onPressed: () {
                          if (msgController.text.isNotEmpty) {
                            db
                                .collection("messages")
                                .doc(chatDocid)
                                .collection("msgDetail")
                                .add({
                                  "content": msgController.text.trim(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
