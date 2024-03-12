import 'package:flutter/material.dart';
import 'login.dart'; // Import the Login widget from login.dart

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NEST',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
       home: const Login(), // Set Login page as the home page
       debugShowCheckedModeBanner: false,
    );
  }
}
