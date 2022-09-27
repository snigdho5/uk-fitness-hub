import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';

class BottomNavbarPage extends StatelessWidget {
  const BottomNavbarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomePage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        selectedFontSize: 13,
        unselectedFontSize: 13,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(calendar,
                width: kDefaultPadding, color: Colors.white),
            activeIcon: Image.asset(calendar,
                width: kDefaultPadding, color: Colors.white),
            label: "Program",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(progress,
                width: kDefaultPadding, color: Colors.white),
            activeIcon: Image.asset(progress,
                width: kDefaultPadding, color: Colors.white),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(result,
                width: kDefaultPadding, color: Colors.white),
            activeIcon: Image.asset(result,
                width: kDefaultPadding, color: Colors.white),
            label: "Results",
          ),
        ],
        onTap: (index) {
          //TODO: Ontap nav items
        },
      ),
    );
  }
}
