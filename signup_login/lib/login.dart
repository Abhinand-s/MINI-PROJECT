import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signup_login/forget.dart';
import 'package:signup_login/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signin()async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar: AppBar(title: const Text("Login")),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(
            controller: email,
            decoration:const InputDecoration(hintText: 'enter email id'),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(hintText: 'enter password'),
          ),
          ElevatedButton(onPressed: (()=>signin()), child:const Text('Login')),
          const SizedBox(height: 30,),
          ElevatedButton(onPressed: (()=>Get.to(const Signup())), child:const Text('Register now')),
          const SizedBox(height: 30,),
          ElevatedButton(onPressed: (()=>Get.to(const Forgot())), child:const Text('Forgot password ?'))
          
        ],),
      ),
    ),
    );
  }
}