import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';
import 'package:ukfitnesshub/views/programme/programme_listing_page.dart';

class BottomNavbarPage extends StatefulWidget {
  const BottomNavbarPage({Key? key}) : super(key: key);

  @override
  State<BottomNavbarPage> createState() => _BottomNavbarPageState();
}

class _BottomNavbarPageState extends State<BottomNavbarPage> {
  bool _showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(
        showSearch: _showSearch,
        onTapClear: () {
          setState(() {
            _showSearch = false;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Image.asset(result,
                width: kDefaultPadding, color: Colors.white),
            activeIcon: Image.asset(result,
                width: kDefaultPadding, color: Colors.white),
            label: "Results",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(search,
                width: kDefaultPadding, color: Colors.white),
            activeIcon: Image.asset(search,
                width: kDefaultPadding, color: Colors.white),
            label: "Search",
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
            setState(() {
              _showSearch = false;
            });
          } else if (index == 3) {
            setState(() {
              _showSearch = !_showSearch;
            });
          }
        },
      ),
    );
  }
}
