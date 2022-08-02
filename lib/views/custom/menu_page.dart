import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/auth_providers.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/auth/login_page.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/profile/profile_page.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: customAppBar(context, title: "Menu", showActionButtons: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: const Text("Profile"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilePage()));
              },
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {},
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app),
              onTap: () async {
                final userProfileRef = ref.read(userHiveProvider);
                final user = userProfileRef.getUser();

                if (user != null) {
                  EasyLoading.show(status: 'loading...');
                  await AuthProvider.logout(token: user.token, userId: user.id)
                      .then((value) async {
                    await userProfileRef.removeUser().then((value) {
                      EasyLoading.dismiss();
                      Navigator.pop(context);
                    });
                  });
                }
              },
            ),
            const Divider(height: 0),
          ],
        ),
      ),
    );
  }
}
