import 'package:flutter/material.dart';

import 'package:medicine_notification/constants.dart';
import 'package:medicine_notification/global_bloc.dart';
import 'package:medicine_notification/pages/home_page.dart';
//import 'package:medicine_notification/pages/new_entry/new_entry_blog.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  GlobalBloc? globalBloc;

  @override
  void initState(){
   globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc!,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'MEDICINE NOTIFICATION',
            theme: ThemeData.dark().copyWith(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: kScaffoldColor,
              appBarTheme:  AppBarTheme(
                toolbarHeight: 7.h,
                backgroundColor: kScaffoldColor,
                elevation: 0
                ,iconTheme: IconThemeData(color: kSecondaryColor,size: 20.sp)
                ,titleTextStyle: TextStyle(
                  color: kTextColor,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.sp
                )
              ),
              
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: kTextColor
              ),
              titleMedium: TextStyle(
                fontSize: 12.sp,
                color: kTextColor
              ),
              bodySmall: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: kPrimaryColor
              ),
              displaySmall: TextStyle(
                fontSize: 28.sp,
                color: kSecondaryColor,
                fontWeight: FontWeight.w500
              ),
              titleLarge: TextStyle(
                fontSize: 18.sp,
                color: kTextColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1.h
              ),
              headlineSmall:TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: kTextColor
              ),
              labelMedium: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: kTextColor,
              )
            ),
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kTextLightColor
                )
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor
                )
              )
            ),
            //timepicker cuztimization
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
              dayPeriodTextStyle: TextStyle(
                fontSize: 8.sp,
                
              )
            )
            ),
            
            
            home: const Homepage(),
          );
        },
      ),
    );
  }
}
