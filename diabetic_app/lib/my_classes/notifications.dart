import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:diabetic_app/my_classes/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class Notifications {
  final User? user = Auth().currentUser;
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
    final fCMToken = await firebaseMessaging.getToken();
    //print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void saveToken(String token) async {
    if(user != null){

    }
  }
}