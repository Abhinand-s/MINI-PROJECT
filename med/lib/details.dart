import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:med/constants.dart';
import 'package:med/main.dart';
import 'package:sizer/sizer.dart';

class MedicineDetail extends StatelessWidget {
  const MedicineDetail({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;

  Future<void> _deleteMedicine(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('medicine').doc(medicine.id).delete();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete medicine: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            MainSection(medicine: medicine),
            ExtendedSection(medicine: medicine),
            const Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => _deleteMedicine(context),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: kScaffoldColor),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}


class MainSection extends StatelessWidget {
  const MainSection({super.key, required this.medicine});
  final Medicine medicine;

  Hero makeIcon(double size) {
    if (medicine.medicineType == 'Bottle') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/bottle.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Pill') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Syringe') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/syringe.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Tablet') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/tablet.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    }
    return Hero(
      tag: medicine.medicineName! + medicine.medicineType!,
      child: Icon(
        Icons.error,
        color: kOtherColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        makeIcon(7.h),
        SizedBox(width: 2.w),
        Column(
          children: [
            Hero(
              tag: medicine.medicineName!,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                  fieldTitle: 'Medicine Name',
                  fieldInfo: medicine.medicineName!,
                ),
              ),
            ),
            MainInfoTab(
              fieldTitle: 'Dosage',
              fieldInfo: medicine.dosage == 0 ? 'Not Specified' : "${medicine.dosage} mg",
            ),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab({
    super.key,
    required this.fieldTitle,
    required this.fieldInfo,
  });

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 0.3.h),
            Text(
              fieldInfo,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final startTimeFormatted = _formatTime(medicine.startTime!);

    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: medicine.medicineType == 'None' ? 'Not Specified' : medicine.medicineType!,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dose interval',
          fieldInfo:
              'Every ${medicine.interval} hours   | ${medicine.interval == 24 ? "One time a day" : "${(24 / medicine.interval!).floor()} times a day"}',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo: startTimeFormatted,
        ),
      ],
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final period = hours >= 12 ? 'pm' : 'am';
    final formattedHours = hours % 12 == 0 ? '12' : (hours % 12).toString();
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes $period';
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab({
    super.key,
    required this.fieldTitle,
    required this.fieldInfo,
  });

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: kTextColor),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kSecondaryColor),
          ),
        ],
      ),
    );
  }
}
