import 'package:chat_connect/models/themes.dart';
import 'package:chat_connect/routes/routes.dart';
import 'package:chat_connect/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.uid, {super.key});
  final String uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    _userDataFuture =
        FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final String _profilePic =
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.kindpng.com%2Fpicc%2Fm%2F252-2524695_dummy-profile-image-jpg-hd-png-download.png&f=1&nofb=1&ipt=764ff544c60a4c0db770079a4cb3c1f537911740c6227cde1f7d9822eb72d82f";

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(child: Text("Failed to load user data"));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>;
          final String user = data['user'];
          final String email = data['email'];

          return ListView(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: tertiaryColor,
                backgroundImage: NetworkImage(_profilePic),
              ),

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Username: ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          user,
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Text(
                          "Email: ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tertiaryColor,
                    foregroundColor: Colors.white,
                    iconSize: 30,
                  ),
                  onPressed: () async {
                    Navigator.pushNamed(context, RouteManager.editPage);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        Text(
                          " Edit",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red1,
                    foregroundColor: red2,
                    iconSize: 30,
                  ),
                  onPressed: () async {
                    await auth.logout();
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/loginPage'),
                    );
                    Navigator.popAndPushNamed(context, RouteManager.loginPage);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_sharp),
                        Text(
                          " Logout",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
