import 'dart:io' show Platform;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ukfitnesshub/config/constants.dart';

Future<void> initPlatformStateForPurchases(String? userId) async {
  //TODO: remove it before production
  await Purchases.setLogLevel(LogLevel.debug);

  PurchasesConfiguration configuration;

  if (Platform.isIOS) {
    configuration = PurchasesConfiguration(SubscriptionConstants.appleApiKey);

    if (userId != null) {
      configuration.appUserID = userId;
    }

    await Purchases.configure(configuration);

    if (userId != null) {
      await Purchases.logIn(userId);
    }
  } else if (Platform.isAndroid) {
    configuration = PurchasesConfiguration(SubscriptionConstants.googleApiKey);

    if (userId != null) {
      configuration.appUserID = userId;
    }

    await Purchases.configure(configuration);

    if (userId != null) {
      await Purchases.logIn(userId);
    }
  }
}
