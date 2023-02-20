import 'package:flutter/material.dart';
import 'package:ukfitnesshub/models/user_profile_model.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';
import 'package:ukfitnesshub/views/settings/subscription_widget.dart';

class Wrapper extends StatefulWidget {
  final UserProfileModel userProfileModel;
  const Wrapper({
    Key? key,
    required this.userProfileModel,
  }) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    DateTime now = DateTime.now();
    DateTime? trialDate = widget.userProfileModel.trialEndDate;

    debugPrint("Now: $now");
    debugPrint("Trial Date: $trialDate");

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
      debugPrint('Trial is not over');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePage(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
