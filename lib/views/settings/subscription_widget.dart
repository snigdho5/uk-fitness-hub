import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/helper/url_launcher_helper.dart';
import 'package:ukfitnesshub/providers/subscriptions/is_subscribed_provider.dart';
import 'package:ukfitnesshub/providers/subscriptions/offerings_provider.dart';

class SubscriptionBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, bool isPremiumUser) builder;

  const SubscriptionBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumUserRef = ref.watch(isPremiumUserProvider);

    return isPremiumUserRef.when(
      data: (data) {
        return builder(context, data);
      },
      error: (error, stackTrace) {
        return builder(context, false);
      },
      loading: () {
        return const SizedBox();
      },
    );
  }

  static Future<void> showSubscriptionDialog({
    required BuildContext context,
    String? message,
    bool isDismissible = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return SubscriptionDialog(message: message);
      },
    );
  }
}

class SubscriptionDialog extends ConsumerWidget {
  final String? message;
  const SubscriptionDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringsRef = ref.watch(subscriptionOfferingsProvider);

    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Your trial has ended!"),
          Text(
            message ?? "Subscribe to unlock premium features!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          offeringsRef.when(
            data: (data) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: data.map(
                    (element) {
                      String title = "";
                      if (element.packageType == PackageType.monthly) {
                        title = element.storeProduct.title.isEmpty
                            ? "Monthly Subscription"
                            : element.storeProduct.title;
                      } else if (element.packageType == PackageType.annual) {
                        title = element.storeProduct.title.isEmpty
                            ? "Annual Subscription"
                            : element.storeProduct.title;
                      }

                      String description = "";
                      if (element.packageType == PackageType.monthly) {
                        description = element.storeProduct.description.isEmpty
                            ? "Full access for a month"
                            : element.storeProduct.description;
                      } else if (element.packageType == PackageType.annual) {
                        description = element.storeProduct.description.isEmpty
                            ? "Full access for a year"
                            : element.storeProduct.description;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          dense: true,
                          onTap: () async {
                            // Navigator.pop(context);
                            EasyLoading.show(status: "Processing...");
                            await Purchases.purchasePackage(element)
                                .then((value) {
                              EasyLoading.dismiss();
                              ref.invalidate(isPremiumUserProvider);
                              ref.invalidate(premiumCustomerInfoProvider);
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              debugPrint(error.toString());

                              EasyLoading.showInfo("Purchase Failed!");
                            });
                          },
                          title: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            description,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Text(
                            element.storeProduct.priceString,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          leading: Text("${data.indexOf(element) + 1}. "),
                          minLeadingWidth: 0,
                        ),
                      );
                    },
                  ).toList());
            },
            error: (error, stackTrace) => const Text("Error loading offers!"),
            loading: () => const SizedBox(),
          ),
          const SizedBox(height: 16),
          const Text("You can cancel anytime!"),
          const SizedBox(height: 16),
          // Privacy Policy and Terms of Use
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text.rich(
              TextSpan(
                text: "By continuing, you agree to our ",
                children: [
                  TextSpan(
                    text: "Privacy Policy",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchURL(privacyPolicy);
                      },
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const TextSpan(text: " and "),
                  TextSpan(
                    text: "Terms of Use",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchURL(termsAndConditions);
                      },
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
