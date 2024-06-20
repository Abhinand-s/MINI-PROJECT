import 'package:firebase_messaging/firebase_messaging.dart';
Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title : ${message.notification?.title}');
  print('payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNOtifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token : $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  }

  void sendNotification(String s, String t) {}

}