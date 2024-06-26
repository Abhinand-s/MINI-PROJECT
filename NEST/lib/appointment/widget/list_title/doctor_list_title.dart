import 'package:flutter/material.dart';
import 'package:signup_login/appointment/screen/doctor_details_screen.dart';
import 'package:models/models.dart'; // Adjust the import based on your project structure
import 'package:signup_login/appointment/widget/list_title/booking.dart';
class DoctorListTile extends StatelessWidget {
  const DoctorListTile({super.key, required this.doctor});
  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DoctorDetailsScreen(doctorId: doctor.id);
        }));
      },
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: colorScheme.background,
        backgroundImage: NetworkImage(doctor.profileImageUrl),
      ),
      title: Text(
        doctor.name,
        style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          Text(
            doctor.category.name,
            style: textTheme.bodyMedium!.copyWith(color: colorScheme.secondary),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orange[200], size: 16),
              const SizedBox(width: 4),
              Text(
                doctor.rating.toString(),
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onBackground.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.work, color: colorScheme.tertiary, size: 16),
              const SizedBox(width: 4),
              Text(
                '3 Years',
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onBackground.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: FilledButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DoctorBookingDetailsScreen(doctor: doctor);
          }));
        },
        child: const Text('Book Now'),
      ),
    );
  }
}
