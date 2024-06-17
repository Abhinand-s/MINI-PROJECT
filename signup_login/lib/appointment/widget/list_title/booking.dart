import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Required for using the Clipboard class
import 'package:models/models.dart'; // Adjust the import based on your project structure

class DoctorBookingDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorBookingDetailsScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorBookingDetailsScreenState createState() => _DoctorBookingDetailsScreenState();
}

class _DoctorBookingDetailsScreenState extends State<DoctorBookingDetailsScreen> {
  bool isBooked = false;

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
