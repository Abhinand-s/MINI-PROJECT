import 'package:flutter/material.dart';

class GridDashboard extends StatelessWidget {
  final Items item1 = Items(
    title: "Calendar",
    subtitle: "March, Wednesday",
    event: "3 Events",
    img: "assets/calendar.png",
  );

  final Items item2 = Items(
    title: "Groceries",
    subtitle: "Bocali, Apple",
    event: "4 Items",
    img: "assets/food.png",
  );

  final Items item3 = Items(
    title: "Locations",
    subtitle: "Lucy Mao going to Office",
    event: "",
    img: "assets/map.png",
  );

  final Items item4 = Items(
    title: "Activity",
    subtitle: "Rose favorited your Post",
    event: "",
    img: "assets/festival.png",
  );

  final Items item5 = Items(
    title: "To do",
    subtitle: "Homework, Design",
    event: "4 Items",
    img: "assets/todo.png",
  );

  final Items item6 = Items(
    title: "Settings",
    subtitle: "",
    event: "2 Items",
    img: "assets/setting.png",
  );

  @override
  Widget build(BuildContext context) {
    final List<Items> myList = [item1, item2, item3, item4, item5, item6];
    final color = 0xff453658;

    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return Container(
            decoration: BoxDecoration(
              color: Color(color),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  data.img,
                  width: 42,
                ),
                SizedBox(height: 14),
                Text(
                  data.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  data.event,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Items {
  final String title;
  final String subtitle;
  final String event;
  final String img;

  Items({required this.title, required this.subtitle, required this.event, required this.img});
}
