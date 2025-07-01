import 'package:chat_connect/routes/routes.dart';
import 'package:chat_connect/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<Auth>(create: (_) => Auth())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chat Connect",
        initialRoute: RouteManager.loadingPage,
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
