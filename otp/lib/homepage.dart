import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleSignOut,
          ),
        ],
      ),
      body: Center(
        child: Text('Logged in as: ${_auth.currentUser!.email}'),
      ),
    );
  }
}
