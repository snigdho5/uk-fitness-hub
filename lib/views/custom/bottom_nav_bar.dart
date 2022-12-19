import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/programme/programme_listing_page.dart';
import 'package:ukfitnesshub/views/progress/progress_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      selectedFontSize: 13,
      unselectedFontSize: 13,
      elevation: 0,
      unselectedIconTheme: const IconThemeData(color: Colors.white),
      selectedIconTheme: const IconThemeData(color: Colors.white),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(calendar,
              width: kDefaultPadding, color: Colors.white),
          activeIcon: Image.asset(calendar,
              width: kDefaultPadding, color: Colors.white),
          label: "Programmes",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(progress,
              width: kDefaultPadding, color: Colors.white),
          activeIcon: Image.asset(progress,
              width: kDefaultPadding, color: Colors.white),
          label: "Progress",
        ),
        BottomNavigationBarItem(
          icon:
              Image.asset(result, width: kDefaultPadding, color: Colors.white),
          activeIcon:
              Image.asset(result, width: kDefaultPadding, color: Colors.white),
          label: "Results",
        ),
      ],
      onTap: (index) {
        //TODO: Ontap nav items
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProgramListingTabView(),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProgressPage(),
            ),
          );
        }
      },
    );
  }
}
