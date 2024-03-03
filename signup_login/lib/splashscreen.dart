import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed( const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.child!),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Image.network('https://drive.google.com/file/d/1o2OHzriD9JvcrJLgJF3hutpISozyGmqY/view?usp=sharing'), // Add your logo image inside assets/images directory
                  SizedBox(height: 20),
                  Text(
                    "NEST",
                    style: TextStyle(color: const Color.fromARGB(255, 2, 7, 3), fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Not Just For New Born Babies..But For New Born Parents Too..",
                    style: TextStyle(color: const Color.fromARGB(255, 3, 16, 4), fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
