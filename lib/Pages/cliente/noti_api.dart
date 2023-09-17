



import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
class Firebaseapi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification(Function(RemoteMessage) onMessage) async {
    await _firebaseMessaging.requestPermission();
    //final fCMToken = await _firebaseMessaging.getToken();
    //print(fCMToken);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(onMessage);
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final firebaseApi = Firebaseapi();

  @override
  void initState() {
    super.initState();
    firebaseApi.initNotification(_showDialog);
  }

  void _showDialog(RemoteMessage message) {
   
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Tu widget aquí
  }
}
