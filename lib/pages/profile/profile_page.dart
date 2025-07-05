import 'package:chat_connect/models/themes.dart';
import 'package:chat_connect/routes/routes.dart';
import 'package:chat_connect/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final String profilePic =
        "https://images.unsplash.com/vector-1738926052638-8c6ed8c582f9?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
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

          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  CircleAvatar(
                    radius: 150,
                    backgroundColor: tertiaryColor,
                    backgroundImage: NetworkImage(profilePic),
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
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
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
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
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
                                fontWeight: FontWeight.bold,
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
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setString("userId", "");
                        await prefs.setBool("isLogin", false);

                        Navigator.popUntil(
                          context,
                          ModalRoute.withName('/loginPage'),
                        );
                        Navigator.pushNamed(context, RouteManager.loginPage);
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
              ),
            ),
          );
        },
      ),
    );
  }
}
