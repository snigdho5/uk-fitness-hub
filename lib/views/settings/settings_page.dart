import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/settings/change_password_page.dart';
import 'package:ukfitnesshub/views/settings/subscription_widget.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Settings", showDefaultActionButtons: false),
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
            ListTile(
              title: const Text("Subscription"),
              leading: const Icon(Icons.subscriptions),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const TrialEndDialog(isTrialEnded: false);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
