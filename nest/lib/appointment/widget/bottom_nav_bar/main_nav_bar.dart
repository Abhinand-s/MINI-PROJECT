import 'package:flutter/material.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onBackground.withOpacity(0.5),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedFontSize: 14,
      selectedLabelStyle: textTheme.bodySmall,
      unselectedLabelStyle: textTheme.bodySmall,
      type: BottomNavigationBarType.fixed,
      onTap: (index){
        switch (index){
          case 0:
          print(index);
          //to do navigation bar
          break;
           case 1:
          print(index);
          break;
          //.....other index
        default:
        }
      },
      
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Discover'),
      BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Booking'),
      BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile')
    ]);
  }
}
