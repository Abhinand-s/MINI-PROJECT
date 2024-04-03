import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signup_login/vaccine/constants.dart';
import 'package:signup_login/vaccine/global_bloc.dart';
import 'package:signup_login/vaccine/models/medicine.dart';
import 'package:signup_login/vaccine/pages/medicine_details/medicine_details.dart';
import 'package:signup_login/vaccine/pages/new_entry/new_entry.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
          //go to entry page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Newentry()));
        },
        child: SizedBox(
          width: 18.w,
          height: 9.h,
          child: Card(
            color: kPrimaryColor,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(3.h)),
            child: Icon(
              Icons.add_outlined,
              color: kScaffoldColor,
              size: 50.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
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
        //show real number

        StreamBuilder<List<Medicine>>(
          stream: globalBloc
              .medicineList$, // Replace 'yourStream' with your actual stream
          builder: (context, snapshot) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(
                !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          },
        ),
      ],
    );
  }
}

class BottonContainer extends StatelessWidget {
  const BottonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    //later we use
    // return Center(
    //   child: Text('No Medicine',
    //   textAlign: TextAlign.center,
    //   ,),
    // );

    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder(
        stream: globalBloc.medicineList$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //if no data is saved
            return Container();
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text('No Medicine',
                  style: Theme.of(context).textTheme.displaySmall),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.only(top: 1.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MedicineCard(
                  medicine: snapshot.data![index],
                );
              },
            );
          }
        });
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;
  //for getting the current details of the saved items

  //first we need to get the medicine type icon
  //lets make a function

  Hero makeIcon(double size) {
    //here is the bug, the capital word of the first letter
    //lets fix
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
    //in case of no medicine type icon selection
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
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        //go to details activity with animation, later

        Navigator.of(context).push(PageRouteBuilder<void>(pageBuilder:
            (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, Widget? child) {
              return Opacity(
                opacity: animation.value,
                child: MedicineDetail(medicine: medicine),
              );
            },
          );
        },
        transitionDuration: const Duration(milliseconds: 500)
        ));
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
            // SvgPicture.asset(
            //   'assets/icons/bottle.svg',
            //   height: 7.h,
            //   color: kOtherColor,
            // ),
            makeIcon(7.h),
            const Spacer(),
            //hero tag
            Hero(
              tag: medicine.medicineName!,
              child: Text(
                medicine.medicineName!,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            // time intervel
            Text(
              medicine.interval == 1
                  ? "Every ${medicine.interval} hours"
                  : "Every ${medicine.interval} hours",
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }
}
