import 'package:chat_connect/models/themes.dart';
import 'package:chat_connect/routes/routes.dart';
import 'package:chat_connect/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

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
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.3, 0.3), // near the top right
            radius: 1,
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

              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final isValid = _formkey.currentState!.validate();
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final value = await auth.handleSignInEmail(
                          _emailController.text,
                          _passwordController.text,
                        );
                        final userDoc =
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(value!.uid)
                                .get();
                        final userData = userDoc.data();
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('userId', value.uid);

                        await prefs.setBool('isLogin', true);

                        Navigator.popAndPushNamed(
                          context,
                          RouteManager.chatList,
                          arguments: value.uid,
                        );
                      } on FirebaseAuthException catch (e) {
                        String msg = "Login Failed";

                        if (e.code == 'user-not-found') {
                          msg = "user not registered";
                        } else if (e.code == 'wrong-password') {
                          msg = "email or password is incorrect";
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
                    child: Text("Login", style: TextStyle(fontSize: 20)),
                  ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamed(context, RouteManager.registerPage);
                },
                child: Text("Don't have an account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
