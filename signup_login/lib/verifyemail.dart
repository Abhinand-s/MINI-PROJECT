import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signup_login/wrapper.dart';
import 'package:signup_login/login.dart'; // import your login page
import 'dart:async';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  Timer? _timer;
  int _start = 30;

  @override
  void initState(){
    sendverifylink();
    startTimer();
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          reload();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  sendverifylink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) => {
      Get.snackbar('Link sent', 'A Link has been send to your email',margin: const EdgeInsets.all(30),snackPosition: SnackPosition.BOTTOM)
    });
  }

  reload() async {
    final user = FirebaseAuth.instance.currentUser!;
    if (!user.emailVerified) {
      await user.delete();
      Get.offAll(Login()); // assuming LoginPage is your login page
    } else {
      await user.reload();
      Get.offAll(const Wrapper());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email, color: Colors.green, size: 50),
                const SizedBox(height: 20),
                const Text(
                  'Open your mail and click on the link provided to verify email and reload this page',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  '$_start',
                  style: TextStyle(fontSize: 48),
                ),
                FloatingActionButton(
                  onPressed: (() => reload()),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.restart_alt_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
