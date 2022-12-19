import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/auth_providers.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/profile/update_profile_page.dart';
import 'package:ukfitnesshub/views/programme/programme_listing_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final userProfileRef = ref.watch(userHiveProvider);
    final user = userProfileRef.getUser();

    print(userProfileRef.getUser()?.token);

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: kDefaultPadding * 4),
            ListTile(
              leading: const BackButton(color: Colors.white),
              minLeadingWidth: 0,
              title: Text(
                "Profile".toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: kDefaultPadding * 2),
            GestureDetector(
              onTap: () async {
                if (user != null) {
                  final ImagePicker picker = ImagePicker();

                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    final imageInBase64 =
                        base64Encode(File(image.path).readAsBytesSync());

                    await AuthProvider.uploadProfileImage(
                            userId: user.id,
                            token: user.token,
                            imageBase64: imageInBase64)
                        .then((value) async {
                      if (value != null) {
                        final userProfileRef = ref.read(userHiveProvider);
                        await userProfileRef.saveUser(value).then((value) {});
                      }
                    });
                  }
                }
              },
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding * 5),
                      ),
                      padding: const EdgeInsets.all(kDefaultPadding / 2),
                      margin: const EdgeInsets.all(kDefaultPadding),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding * 5),
                        child: user?.image == null ||
                                user?.image == "na" ||
                                user!.image.isEmpty
                            ? const Icon(Icons.person,
                                size: kDefaultPadding * 5, color: Colors.white)
                            : CachedNetworkImage(
                                imageUrl: user.image,
                                height: kDefaultPadding * 5,
                                width: kDefaultPadding * 5,
                                placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline,
                                        size: kDefaultPadding * 3,
                                        color: Colors.white),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: kDefaultPadding * 1.5,
                      right: kDefaultPadding * 1.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(kDefaultPadding * 10),
                        ),
                        padding: const EdgeInsets.all(kDefaultPadding / 3),
                        child: const Icon(Icons.edit,
                            color: Colors.black, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            Center(
              child: Text(
                user?.name ?? "User",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding * 3),
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Update Information"),
                        subtitle: const Text("Edit your account details."),
                        leading: const Icon(Icons.edit),
                        onTap: () {
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(user: user),
                              ),
                            );
                          }
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                          title: const Text("Create your own program"),
                          subtitle: const Text("Make your own workout videos"),
                          leading: const Icon(Icons.video_library),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProgramListingTabView(),
                              ),
                            );
                          }),
                      const Divider(height: 0),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
