import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final subscriptionOfferingsProvider =
    FutureProvider<List<Package>>((ref) async {
  final offerings = await Purchases.getOfferings();

  if (offerings.current != null &&
      offerings.current!.availablePackages.isNotEmpty) {
    return offerings.current!.availablePackages;
  } else {
    return [];
  }
});
