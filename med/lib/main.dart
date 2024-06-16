import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med/constants.dart';
import 'package:med/newentry.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/details.dart'; // Import the MedicineDetail page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'MEDICINE NOTIFICATION',
          theme: ThemeData.dark().copyWith(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: kScaffoldColor,
              appBarTheme: AppBarTheme(
                  toolbarHeight: 7.h,
                  backgroundColor: kScaffoldColor,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: kSecondaryColor, size: 20),
                  titleTextStyle: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.sp)),
              textTheme: TextTheme(
                  headlineMedium: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: kTextColor),
                  titleMedium: TextStyle(fontSize: 12.sp, color: kTextColor),
                  bodySmall: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                      color: kPrimaryColor),
                  displaySmall: TextStyle(
                      fontSize: 28.sp,
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w500),
                  titleLarge: TextStyle(
                      fontSize: 18.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1.h),
                  headlineSmall: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: kTextColor),
                  labelMedium: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: kTextColor,
                  )),
              inputDecorationTheme: const InputDecorationTheme(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kTextLightColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor))),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: kScaffoldColor,
                hourMinuteColor: kTextColor,
                hourMinuteTextColor: kScaffoldColor,
                dayPeriodColor: kTextColor,
                dayPeriodTextColor: kScaffoldColor,
                dialBackgroundColor: kTextColor,
                dialHandColor: kPrimaryColor,
                dialTextColor: kScaffoldColor,
                entryModeIconColor: kOtherColor,
                dayPeriodTextStyle: TextStyle(fontSize: 8.sp),
              )),
          home: const Homepage(),
        );
      },
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            const TopContainer(),
            SizedBox(height: 2.h),
            const Flexible(child: BottonContainer())
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewEntryUI()),
          );
        },
        child: SizedBox(
          width: 18.w,
          height: 9.h,
          child: Card(
            color: Colors.blue,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(3.h)),
            child: Icon(
              Icons.add_outlined,
              color: Colors.white,
              size: 50.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'Worry less. \nLive Healthier.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'Welcome to Daily Dose.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        const MedicineCount(), // Widget to show the number of medicines
      ],
    );
  }
}

class BottonContainer extends StatelessWidget {
  const BottonContainer({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('medicine').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Medicine',
                  style: Theme.of(context).textTheme.displaySmall),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.only(top: 1.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final medicine = Medicine(
                  id: doc.id,
                  medicineName: doc['name'],
                  medicineType: doc['type'],
                  interval: doc['interval'],
                  startTime: doc['time'],
                  dosage: doc['dosage']
                );
                return MedicineCard(medicine: medicine);
              },
            );
          }
        });
  }
}

class MedicineCount extends StatelessWidget {
  const MedicineCount({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('medicine').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
            '0',
            style: Theme.of(context).textTheme.headlineMedium,
          );
        }

        final count = snapshot.data!.docs.length;
        return Text(
          '$count',
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineDetail(medicine: medicine),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(2.h)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Hero(
              tag: medicine.medicineName + medicine.medicineType,
              child: SvgPicture.asset(
                _getMedicineIcon(medicine.medicineType),
                color: Colors.blue,
                height: 7.h,
              ),
            ),
            const Spacer(),
            Hero(
              tag: medicine.medicineName,
              child: Text(
                medicine.medicineName,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Text(
              "Every ${medicine.interval} hours",
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Text(
              "Start from: ${medicine.startTime}",
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  String _getMedicineIcon(String medicineType) {
    switch (medicineType) {
      case 'Bottle':
        return 'assets/icons/bottle.svg';
      case 'Pill':
        return 'assets/icons/pill.svg';
      case 'Syringe':
        return 'assets/icons/syringe.svg';
      default:
        return 'assets/icons/pill.svg';
    }
  }
}

class Medicine {
  final String id;
  final String medicineName;
  final String medicineType;
  final int interval;
  final String startTime;
  final String dosage; // Add this line to match the structure in details.dart

  Medicine({
    required this.id,
    required this.medicineName,
    required this.medicineType,
    required this.interval,
    required this.startTime,
    required this.dosage, // Add this line to match the structure in details.dart
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': medicineName,
      'type': medicineType,
      'interval': interval,
      'time': startTime,
      'dosage':dosage
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      medicineName: map['name'],
      medicineType: map['type'],
      interval: map['interval'],
      startTime: map['time'],
      dosage:map['dosage']
    );
  }
}

