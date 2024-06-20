import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Required for using the Clipboard class
import 'package:models/models.dart'; // Adjust the import based on your project structure
import 'package:firebase_messaging/firebase_messaging.dart';

class DoctorBookingDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorBookingDetailsScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorBookingDetailsScreenState createState() => _DoctorBookingDetailsScreenState();
}

class _DoctorBookingDetailsScreenState extends State<DoctorBookingDetailsScreen> {
  bool isBooked = false;
  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  void initState() {
    super.initState();
    _firebaseApi.initNotifications();
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $phoneNumber')),
        );
      }
    } catch (e) {
      print('Error launching phone call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching phone call')),
      );
    }
  }

  void _copyPhoneNumberToClipboard(String phoneNumber) {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Phone number copied to clipboard')),
    );
  }

  void _sendBookingNotification() {
    _firebaseApi.sendNotification(
      'Booking Confirmed',
      'You have marked Dr. ${widget.doctor.name} as booked.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: colorScheme.background,
              backgroundImage: NetworkImage(widget.doctor.profileImageUrl),
            ),
            const SizedBox(height: 16.0),
            Text(widget.doctor.name, style: textTheme.headline5),
            const SizedBox(height: 8.0),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _makePhoneCall(widget.doctor.phoneNumber),
                  icon: Icon(Icons.call),
                  label: Text('Call Doctor'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton.icon(
                  onPressed: () => _copyPhoneNumberToClipboard(widget.doctor.phoneNumber),
                  icon: Icon(Icons.copy),
                  label: Text('Copy Phone Number'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: isBooked,
                  onChanged: (bool? value) {
                    setState(() {
                      isBooked = value ?? false;
                      if (isBooked) {
                        _sendBookingNotification();
                      }
                    });
                  },
                ),
                const SizedBox(width: 8.0),
                Text('Mark as Booked', style: textTheme.bodyText1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Payload: ${message.data}');
  }

  Future<void> sendNotification(String title, String body) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: 'payload',
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}

