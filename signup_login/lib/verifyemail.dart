import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signup_login/wrapper.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  void initState(){
    sendverifylink();
    super.initState();
  }
  sendverifylink()async{
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value)=>{
      Get.snackbar('Link sent', 'A Link has been send to your email',margin: const EdgeInsets.all(30),snackPosition: SnackPosition.BOTTOM)
    });
  }
  reload()async{
    await FirebaseAuth.instance.currentUser!.reload().then((value) => {Get.offAll(const Wrapper())});
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
