import 'package:chat_connect/models/themes.dart';
import 'package:chat_connect/models/user_data.dart';
import 'package:chat_connect/routes/routes.dart';
import 'package:chat_connect/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login"), automaticallyImplyLeading: false),
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusColor: secondaryColor,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "email is required";
                  }
                  return null;
                },
                controller: _emailController,
                style: TextStyle(color: primaryColor),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusColor: secondaryColor,
                ),
                controller: _passwordController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  } else if (value.length < 8) {
                    return "password should be at least 8 characters";
                  }
                  return null;
                },
                style: TextStyle(color: primaryColor),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final isValid = _formkey.currentState!.validate();

                await auth
                    .handleSignInEmail(
                      _emailController.text,
                      _passwordController.text,
                    )
                    .then((value) async {
                      final userDoc =
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(value!.uid)
                              .get();
                      final userData = userDoc.data();
                      UserData dataObject = UserData(value.uid, userData!);

                      Navigator.popAndPushNamed(
                        context,
                        RouteManager.chatList,
                        arguments: dataObject,
                      );
                      //   Navigator.popAndPushNamed(
                      //     context,
                      //     RouteManager.profilePage,
                      //     arguments: dataObject,
                      //   );
                    })
                    .catchError((e) => print(e));
              },
              child: Text("Login", style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.popAndPushNamed(context, RouteManager.registerPage);
              },
              child: Text("Don't have an account?"),
            ),
          ],
        ),
      ),
    );
  }
}
