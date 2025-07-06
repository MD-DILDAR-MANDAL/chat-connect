import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoading = false;
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
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        foregroundColor: Colors.white,
        backgroundColor: secondaryColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.3, 0.3), // near the top right
            radius: 1.1,
            colors: <Color>[
              Colors.white, // yellow sun
              secondaryColor, // blue sky
            ],
            stops: <double>[0.9, 0.7],
          ),
        ),

        child: Form(
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

              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isLoading = true;
                      });
                      final isValid = _formkey.currentState!.validate();

                      try {
                        final value = await auth.handleSignUp(
                          _emailController.text,
                          _passwordController.text,
                        );
                        currentUid = value?.uid;
                        FirebaseFirestore db = FirebaseFirestore.instance;

                        Map<String, dynamic> userData = {
                          "user": _userController.text,
                          "email": _emailController.text,
                        };

                        db.collection("users").doc(currentUid).set(userData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("registration successfull"),
                            backgroundColor: secondaryColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        Navigator.popAndPushNamed(
                          context,
                          RouteManager.loginPage,
                        );
                      } on FirebaseAuthException catch (e) {
                        String msg = "registration failed";
                        if (e.code == 'email-already-in-use') {
                          msg = "Email is already in use";
                        } else if (e.code == 'invalid-email') {
                          msg = "Invalid email format";
                        } else {
                          msg = e.message ?? msg;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            backgroundColor: red2,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: Text("connect", style: TextStyle(fontSize: 20)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
