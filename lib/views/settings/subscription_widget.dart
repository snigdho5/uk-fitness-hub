import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ukfitnesshub/providers/subscriptions/is_subscribed_provider.dart';
import 'package:ukfitnesshub/providers/subscriptions/offerings_provider.dart';

class SubscriptionBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, bool isPremiumUser) builder;

  const SubscriptionBuilder({Key? key, required this.builder})
      : super(key: key);

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
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      content: offeringsRef.when(
        data: (data) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: data.map(
                (element) {
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
                        await Purchases.purchasePackage(element).then((value) {
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
                        element.storeProduct.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        element.storeProduct.description,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Text(
                        element.storeProduct.priceString,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
    );
  }
}
