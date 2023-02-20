import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ukfitnesshub/config/constants.dart';

final isPremiumUserProvider = FutureProvider<bool>((ref) async {
  final CustomerInfo customerInfo = await Purchases.getCustomerInfo();

  debugPrint("Customer Info: $customerInfo");

  if (customerInfo.entitlements.all[SubscriptionConstants.entitlementId] !=
          null &&
      customerInfo.entitlements.all[SubscriptionConstants.entitlementId]!
              .isActive ==
          true) {
    return true;
  } else {
    return false;
  }
});

final premiumCustomerInfoProvider = FutureProvider<CustomerInfo>((ref) async {
  final CustomerInfo customerInfo = await Purchases.getCustomerInfo();

  debugPrint("Customer Info: $customerInfo");

  return customerInfo;
});
