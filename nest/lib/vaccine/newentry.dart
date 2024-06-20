import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signup_login/vaccine/constants.dart';
import 'package:signup_login/vaccine/success.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewEntryUI extends StatefulWidget {
  final String childName;

  const NewEntryUI({Key? key, required this.childName}) : super(key: key);

  @override
  _NewEntryUIState createState() => _NewEntryUIState();
}

class _NewEntryUIState extends State<NewEntryUI> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  String? selectedMedicineType;
  int? selectedInterval;
  TimeOfDay? selectedTime;

  void selectMedicineType(String type) {
    setState(() {
      selectedMedicineType = type;
    });
  }

  void selectInterval(int? interval) {
    setState(() {
      selectedInterval = interval;
    });
  }

  void selectTime(TimeOfDay time) {
    setState(() {
      selectedTime = time;
    });
  }

  Future<void> addMedicineEntry() async {
    if (nameController.text.isNotEmpty &&
        selectedInterval != null &&
        selectedTime != null) {
      await FirebaseFirestore.instance.collection('medicine').add({
        'childName': widget.childName,
        'name': nameController.text,
        'dosage': dosageController.text,
        'type': selectedMedicineType,
        'interval': selectedInterval,
        'time': '${selectedTime!.hour}:${selectedTime!.minute}',
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } else {
      // Show error message if required fields are missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PanelTitle(
                title: 'Medicine Name',
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
                    .subtitle2!
                    .copyWith(color: kOtherColor),
              ),
              const PanelTitle(
                title: 'Dosage in mg',
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
                    .subtitle2!
                    .copyWith(color: kOtherColor),
              ),
              SizedBox(
                height: 2.h,
              ),
              const PanelTitle(title: 'Medicine Type', isRequired: false),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MedicineTypeColumn(
                      name: 'Bottle',
                      iconValue: 'assets/icons/bottle.svg',
                      isSelected: selectedMedicineType == 'Bottle',
                      onTap: () => selectMedicineType('Bottle'),
                    ),
                    MedicineTypeColumn(
                      name: 'Pill',
                      iconValue: 'assets/icons/pill.svg',
                      isSelected: selectedMedicineType == 'Pill',
                      onTap: () => selectMedicineType('Pill'),
                    ),
                    MedicineTypeColumn(
                      name: 'Syringe',
                      iconValue: 'assets/icons/syringe.svg',
                      isSelected: selectedMedicineType == 'Syringe',
                      onTap: () => selectMedicineType('Syringe'),
                    ),
                    MedicineTypeColumn(
                      name: 'Tablet',
                      iconValue: 'assets/icons/tablet.svg',
                      isSelected: selectedMedicineType == 'Tablet',
                      onTap: () => selectMedicineType('Tablet'),
                    ),
                  ],
                ),
              ),
              const PanelTitle(title: 'Interval Selection', isRequired: true),
              IntervalSelection(onSelect: selectInterval),
              const PanelTitle(title: 'Starting Time', isRequired: true),
              SelectTime(onSelect: selectTime),
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
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: kScaffoldColor,
                            ),
                      ),
                    ),
                    onPressed: addMedicineEntry,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectTime extends StatefulWidget {
  final Function(TimeOfDay) onSelect;
  const SelectTime({Key? key, required this.onSelect}) : super(key: key);

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<void> _selectTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
      });
      widget.onSelect(_time);
    }
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
          onPressed: _selectTime,
          child: Center(
            child: Text(
              _clicked == false ? "Select Time" : "${_time.format(context)}",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: kScaffoldColor),
            ),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  final Function(int?) onSelect;
  const IntervalSelection({Key? key, required this.onSelect}) : super(key: key);

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [1,6, 8, 12, 24];
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remind me every',
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: kTextColor,
                ),
          ),
          DropdownButton<int>(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            //itemHeight: 48.h,
            hint: _selected == null
                ? Text(
                    'Select an Interval',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: kPrimaryColor,
                        ),
                  )
                : null,
            elevation: 4,
            value: _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: kSecondaryColor,
                        ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(() {
                _selected = newVal;
                widget.onSelect(_selected);
              });
            },
          ),
          Text(
            _selected == 1 ? " hour" : " hours",
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: kTextColor),
          ),
        ],
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn({
    Key? key,
    required this.name,
    required this.iconValue,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String iconValue;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
         
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.h),
              color: isSelected ? kOtherColor : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 1.h,
                  bottom: 1.h,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 5.h,
                  color: isSelected ? Colors.white : kOtherColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              name,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: isSelected ? kOtherColor : Colors.white,
                  ),
            ),
          ),
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
      padding: EdgeInsets.only(
        top: 1.5.h,
        bottom: 0.5.h,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: kTextColor),
          ),
          SizedBox(
            width: 1.w,
          ),
          isRequired
              ? Text(
                  "*",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.red),
                )
              : Container(),
        ],
      ),
    );
  }
}
