import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/user_profile_model.dart';
import 'package:ukfitnesshub/providers/subscriptions/init_purchase_conf.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';
import 'package:ukfitnesshub/views/settings/subscription_widget.dart';

class Wrapper extends ConsumerStatefulWidget {
  final UserProfileModel userProfileModel;
  const Wrapper({
    Key? key,
    required this.userProfileModel,
  }) : super(key: key);

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  @override
  void initState() {
    checkPremium();
    super.initState();
  }

  Future<void> checkPremium() async {
    await initPlatformStateForPurchases(widget.userProfileModel.id)
        .then((value) async {
      DateTime now = DateTime.now();
      DateTime? trialDate = widget.userProfileModel.trialEndDate;

      debugPrint("Now: $now");
      debugPrint("Trial Date: $trialDate");

      if (trialDate != null && trialDate.isBefore(now)) {
        await Purchases.getCustomerInfo().then((customerInfo) async {
          if (customerInfo
                      .entitlements.all[SubscriptionConstants.entitlementId] !=
                  null &&
              customerInfo.entitlements
                      .all[SubscriptionConstants.entitlementId]!.isActive ==
                  true) {
            debugPrint('User is premium');
          } else {
            await SubscriptionBuilder.showSubscriptionDialog(context: context);
          }
        });
      } else {
        debugPrint('Trial is not over');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePage(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
