import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'griddashboard.dart';
void main() => runApp(const MaterialApp(home: Home()));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff392850),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Johny s Family",
                      style: 
                         TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Home",
                      style:  TextStyle(
                              color: Color(0xffa29aac),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                IconButton(
                  alignment: Alignment.topCenter,
                  icon: Image.asset(
                    "assets/notification.png",
                    width: 24,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
         GridDashboard()
        ],
      ),
    );
  }
}
