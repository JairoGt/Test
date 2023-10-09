import 'package:appseguimiento/Pages/admin_page.dart';
import 'package:appseguimiento/Pages/asignacion_page.dart';
import 'package:appseguimiento/Pages/client_page.dart';
import 'package:flutter/material.dart';

import 'exports.dart';


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


  

