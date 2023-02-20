import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/helper/date_helpers.dart';
import 'package:ukfitnesshub/helper/url_launcher_helper.dart';
import 'package:ukfitnesshub/providers/subscriptions/is_subscribed_provider.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/settings/change_password_page.dart';
import 'package:ukfitnesshub/views/settings/subscription_widget.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: customAppBar(context, title: "Settings"),
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: const Text("Change Password"),
              leading: const Icon(Icons.lock),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage()));
              },
            ),
            const Divider(height: 0),
            SubscriptionBuilder(builder: (context, isPremiumUser) {
              return Consumer(
                builder: (context, ref, child) {
                  final premiumCustomerRef =
                      ref.watch(premiumCustomerInfoProvider);

                  return premiumCustomerRef.when(
                    data: (data) {
                      final EntitlementInfo? entitlementInfo = data.entitlements
                          .all[SubscriptionConstants.entitlementId];

                      DateTime? expirationDate =
                          entitlementInfo?.expirationDate != null
                              ? DateTime.parse(entitlementInfo!.expirationDate!)
                              : null;

                      return ListTile(
                        title: const Text("Subscription"),
                        trailing: const Icon(CupertinoIcons.chevron_forward),
                        leading: const Icon(CupertinoIcons.star_circle_fill),
                        subtitle: isPremiumUser
                            ? const Text("You are a premium user!")
                            : const Text("Not subscribed"),
                        onTap: () {
                          if (isPremiumUser) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Premium Status"),
                                  content: expirationDate != null
                                      ? Text(
                                          "You are a premium user.\n\n Your subscription will expire on\n${DateHelpers.getFormattedTime(expirationDate)}.")
                                      : null,
                                  actions: [
                                    TextButton(
                                      child: const Text("Close"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Manage"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (data.managementURL != null) {
                                          launchURL(data.managementURL!);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            SubscriptionBuilder.showSubscriptionDialog(
                                context: context,
                                message:
                                    "To get access to premium features, you can subscribe to the premium plan.");
                          }
                        },
                      );
                    },
                    error: (error, stackTrace) => const SizedBox(),
                    loading: () => const SizedBox(),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
