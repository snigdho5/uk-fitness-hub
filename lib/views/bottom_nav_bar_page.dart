import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/user_profile_model.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';
import 'package:ukfitnesshub/views/programme/programme_listing_page.dart';
import 'package:ukfitnesshub/views/progress/progress_page.dart';
import 'package:ukfitnesshub/views/settings/subscription_widget.dart';

class BottomNavbarPage extends StatefulWidget {
  final UserProfileModel userProfileModel;
  const BottomNavbarPage({
    Key? key,
    required this.userProfileModel,
  }) : super(key: key);

  @override
  State<BottomNavbarPage> createState() => _BottomNavbarPageState();
}

class _BottomNavbarPageState extends State<BottomNavbarPage> {
  bool _showSearch = false;

  @override
  void initState() {
    DateTime now = DateTime.now();
    DateTime? trialDate = widget.userProfileModel.trialEndDate;

    print("Now: $now");
    print("Trial Date: $trialDate");

    if (trialDate != null && trialDate.isBefore(now)) {
      Future.delayed(const Duration(seconds: 1), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const TrialEndDialog();
          },
        );
      });
    } else {
      print('Trial is not over');
    }

    super.initState();
  }

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
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProgressPage(),
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
