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
                final isValid = _formkey.currentState!.validate();
                await auth
                    .handleSignUp(
                      _emailController.text,
                      _passwordController.text,
                    )
                    .then((value) {
                      Navigator.popAndPushNamed(
                        context,
                        RouteManager.profilePage,
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
