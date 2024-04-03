import 'dart:math';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signup_login/vaccine/commom/convert_time.dart';
import 'package:signup_login/vaccine/constants.dart';
import 'package:signup_login/vaccine/global_bloc.dart';
import 'package:signup_login/vaccine/models/errors.dart';
import 'package:signup_login/vaccine/models/medicine.dart';
import 'package:signup_login/vaccine/models/medicine_type.dart';
import 'package:signup_login/vaccine/pages/home_page.dart';

import 'package:signup_login/vaccine/pages/new_entry/new_entry_blog.dart';
import 'package:signup_login/vaccine/pages/success_screen/success_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Newentry extends StatefulWidget {
  const Newentry({Key? key}) : super(key: key);

  @override
  State<Newentry> createState() => _NewentryState();
}

class _NewentryState extends State<Newentry> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late NewEntryBloc _newEntryBloc;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late GlobalKey<ScaffoldState> _scaffoldkey;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _newEntryBloc = NewEntryBloc();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PanelTitle(
              title: "Medicine Name",
              isRequired: true,
            ),
            TextFormField(
              maxLength: 12,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: kOtherColor),
            ),
            const PanelTitle(
              title: "Dosage in mg",
              isRequired: false,
            ),
            TextFormField(
              maxLength: 12,
              controller: dosageController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: kOtherColor),
            ),
            SizedBox(
              height: 2.h,
            ),
            const PanelTitle(title: 'Medicine Type', isRequired: false),
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: StreamBuilder<MedicineType>(
                stream: _newEntryBloc.selectedMedicineType,
                builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MedicineTypeColumn(
                        medicineType: MedicineType.Bottle,
                        name: 'Bottle',
                        iconValue: 'assets/icons/bottle.svg',
                        isSelected:
                            snapshot.data == MedicineType.Bottle ? true : false,
                      ),
                      MedicineTypeColumn(
                        medicineType: MedicineType.Pill,
                        name: 'Pill',
                        iconValue: 'assets/icons/pill.svg',
                        isSelected:
                            snapshot.data == MedicineType.Pill ? true : false,
                      ),
                      MedicineTypeColumn(
                        medicineType: MedicineType.Syringe,
                        name: 'Syringe',
                        iconValue: 'assets/icons/syringe.svg',
                        isSelected: snapshot.data == MedicineType.Syringe
                            ? true
                            : false,
                      ),
                      MedicineTypeColumn(
                        medicineType: MedicineType.Tablet,
                        name: 'Tablet',
                        iconValue: 'assets/icons/tablet.svg',
                        isSelected:
                            snapshot.data == MedicineType.Tablet ? true : false,
                      )
                    ],
                  );
                },
              ),
            ),
            const PanelTitle(title: 'Interval Selection', isRequired: true),
            const IntervalSelection(),
            const PanelTitle(title: 'Starting time', isRequired: true),
            const SelectTime(),
            SizedBox(
              height: 2.h,
            ),
            Padding(
                padding: EdgeInsets.only(
                  left: 8.w,
                  right: 8.w,
                ),
                child: SizedBox(
                    width: 80.w,
                    height: 8.h,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: const StadiumBorder(),
                        ),
                        child: Center(
                          child: Text(
                            'Confirm',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: kScaffoldColor,
                                ),
                          ),
                        ),
                        onPressed: () {
                          //add medicine
                          //add some validation
                          String? medicineName;
                          int? dosage;
                          if (nameController.text == "") {
                            _newEntryBloc.submitError(EntryError.nameNull);
                            return;
                          }
                          if (nameController.text != "") {
                            medicineName = nameController.text;
                          }
                          if (dosageController.text == "") {
                            dosage = 0;
                          }
                          if (dosageController.text != "") {
                            dosage = int.parse(dosageController.text);
                          }
                          for (var medicine
                              in globalBloc.medicineList$!.value) {
                            if (medicineName == medicine.medicineName) {
                              _newEntryBloc
                                  .submitError(EntryError.nameDuplicate);
                              return;
                            }
                          }
                          if (_newEntryBloc.selectIntervals!.value == 0) {
                            _newEntryBloc.submitError(EntryError.interval);
                            return;
                          }
                          if (_newEntryBloc.selectedTimeOfDay$!.value ==
                              'None') {
                            _newEntryBloc.submitError(EntryError.startTime);
                            return;
                          }
                          String medicineType = _newEntryBloc
                          .selectedMedicineType!.value
                          .toString()
                          .substring(13);

                      int interval = _newEntryBloc.selectIntervals!.value;
                      String startTime =
                          _newEntryBloc.selectedTimeOfDay$!.value;

                          List<int> intIDs =
                          makeIDs(24 / _newEntryBloc.selectIntervals!.value);
                          List<String> notificationIDs =
                          intIDs.map((i) => i.toString()).toList();

                          Medicine newEntryMedicine = Medicine(
                          notificationIDs: notificationIDs,
                          medicineName: medicineName,
                          dosage: dosage,
                          medicineType: medicineType,
                          interval: interval,
                          startTime: startTime);

                          globalBloc.updateMedicineList(newEntryMedicine);

                          //notification
                          scheduleNotification(newEntryMedicine);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SuccessScreen()));

                        })))
          ]),
        ),
      ),
    );
  }
    void initializeErrorListen() {
    _newEntryBloc.errorState$!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError("Please enter the medicine's name");
          break;

        case EntryError.nameDuplicate:
          displayError("Medicine name already exists");
          break;
        case EntryError.dosage:
          displayError("Please enter the dosage required");
          break;
        case EntryError.interval:
          displayError("Please select the reminder's interval");
          break;
        case EntryError.startTime:
          displayError("Please select the reminder's starting time");
          break;
        default:
      }
    });
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kOtherColor,
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

   List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }
   initializeNotifications() async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/launcher_icon');

  var initializationSettingsIOS =  const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future onSelectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => const Homepage()));
}

Future<void> scheduleNotification(Medicine medicine) async {
  var timeParts = medicine.startTime!.split(':');
  var hour = int.parse(timeParts[0]);
  var ogValue = hour;
  var minute = int.parse(timeParts[1]);

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'repeatDailyAtTime channel id', 'repeatDailyAtTime channel name',
      importance: Importance.max,
      ledColor: kOtherColor,
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true);

  var iOSPlatformChannelSpecifics =  const DarwinNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
    if (hour + (medicine.interval! * i) > 23) {
      hour = hour + (medicine.interval! * i) - 24;
    } else {
      hour = hour + (medicine.interval! * i);
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(medicine.notificationIDs![i]),
        'Reminder: ${medicine.medicineName}',
        medicine.medicineType.toString() != MedicineType.None.toString()
            ? 'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to schedule'
            : 'It is time to take your medicine, according to schedule',
        tz.TZDateTime.now(tz.local).add(Duration(hours: hour, minutes: minute)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    hour = ogValue;
  }
}

}



class SelectTime extends StatefulWidget {
  const SelectTime({Key? key}) : super(key: key);

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime() async {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context,listen: false);
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;

        //update state via provider, we will do later
        newEntryBloc.updateTime(convertTime(_time.hour.toString()) +
        convertTime(_time.minute.toString()));
      });
    }
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: kPrimaryColor, shape: const StadiumBorder()),
          onPressed: () {
            _selectTime();
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Select Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: kScaffoldColor),
            ),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _Intervals = [6, 8, 12, 24];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context) ;
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remind me every',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: 8.h,
            hint: _selected == 0
                ? Text(
                    'Select an interval',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: kSecondaryColor),
                  )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _Intervals.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                _selected = newVal!;
                newEntryBloc.updateInterval(newVal);
              });
            },
          ),
          Text(
            _selected == 1 ? "Hour" : "Hours",
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {super.key,
      required this.name,
      required this.iconValue,
      required this.isSelected,
      required this.medicineType});
  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        //select medicine type
        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.h),
                color: isSelected ? kOtherColor : Colors.white),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                child: SvgPicture.asset(
                  iconValue,
                  height: 7.h,
                  // ignore: deprecated_member_use
                  color: isSelected ? Colors.white : kOtherColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: isSelected ? Colors.white : kOtherColor),
              )),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({Key? key, required this.title, required this.isRequired})
      : super(key: key);
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextSpan(
              text: isRequired ? "*" : "",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}