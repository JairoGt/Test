import 'package:appseguimiento/auth/auth_page.dart';
import 'package:appseguimiento/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldKey,
      title: 'Flutter Demo',
      theme: AppTheme(selectedColor: 2).theme(),
      debugShowCheckedModeBanner: false,
     
      home: const AuthPage(),
    );
  }
}


  

