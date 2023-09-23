import 'dart:ui';

import 'package:appseguimiento/Pages/MotoristaPage/moto_asignado.dart';
import 'package:appseguimiento/Pages/admin_page.dart';
import 'package:appseguimiento/Pages/asignacion_page.dart';
import 'package:appseguimiento/Pages/client_page.dart';
import 'package:appseguimiento/Pages/cliente/cliente2.dart';
import 'package:appseguimiento/Pages/cliente/noti_api.dart';
import 'package:appseguimiento/Pages/list_page.dart';
import 'package:appseguimiento/auth/auth_page.dart';
import 'package:appseguimiento/auth/login.dart';
import 'package:appseguimiento/theme/app_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await Firebaseapi().initNotification((message) {
   // print('Message received: ${message.notification?.body}');

 _showFCMNotification(message.notification?.title ?? '', message.notification?.body ?? '');
  });

  // Display the notification directly
     FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

  runApp(const MyApp());
}

void _showFCMNotification(String title, String body) {
  // Use your preferred method to display notifications here
  // For example, you can use Flutter's built-in snackbar or a custom notification widget
  // Example using ScaffoldMessenger for snackbar:
  _scaffoldKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(body),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Handle the action if needed
        },
      ),
    ),
  );
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
      theme: AppTheme(selectedColor: 7).theme(context),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {
        '/asignacion': (context) => const AsignarPedidos(),
        '/listaPedidos':(context) => const PedidosPage(),
        '/admin' :(context) => const AdminScreen(),
        '/login' :(context) => const Login(),
        '/motoasignado' :(context) => const MotoPage(),
        '/cliente' :(context) => const ClientScreen(),
        '/tracking':(context) => const ClienteTrack(),
       
      },
      home: const AuthPage(),
    );
  }
}


  

