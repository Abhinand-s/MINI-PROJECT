

import 'package:signup_login/appointment/repositories/doctor_repository.dart';
import 'package:signup_login/appointment/screen/Home_screen.dart';
import 'package:signup_login/appointment/shared/themes/app_theme.dart';
import 'package:signup_login/appointment/state/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final doctorRepository = DoctorRepository();
  runApp(AppScreen(doctorRepository: doctorRepository));
}

class AppScreen extends StatelessWidget {
  const AppScreen({super.key, required this.doctorRepository});

  final DoctorRepository doctorRepository;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: doctorRepository,
          //create other instances of repositories to make available to the app
        ),
      ],
      
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(doctorRepository: doctorRepository)..add(LoadHomeEvent()),
            
          ),
          
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: const AppTheme().themeData,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
