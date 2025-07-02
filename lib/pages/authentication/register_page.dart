import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_connect/models/themes.dart';
import 'package:chat_connect/routes/routes.dart';
import 'package:chat_connect/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    var currentUid;

    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusColor: secondaryColor,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "username is required !";
                  }
                  return null;
                },
                controller: _userController,
                style: TextStyle(color: primaryColor),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
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
                  labelText: "Password",
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
                    .handleSignUp(
                      _emailController.text,
                      _passwordController.text,
                    )
                    .then((value) {
                      currentUid = value?.uid;
                      FirebaseFirestore db = FirebaseFirestore.instance;
                      Map<String, dynamic> userData = {
                        "user": _userController.text,
                        "email": _emailController.text,
                      };

                      db.collection("users").doc(currentUid).set(userData);

                      Navigator.popAndPushNamed(
                        context,
                        RouteManager.loginPage,
                      );
                    })
                    .catchError((e) => print(e));
              },
              child: Text("connect", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
