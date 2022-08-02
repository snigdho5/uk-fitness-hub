import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final userProfileRef = ref.watch(userHiveProvider);
    final userImage = userProfileRef.getUser()?.image;
    final userName = userProfileRef.getUser()?.name;

    return Scaffold(
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
                // if (user != null) {
                //   final ImagePicker picker = ImagePicker();

                //   final XFile? image =
                //       await picker.pickImage(source: ImageSource.gallery);

                //   if (image != null) {
                //     final userFuture = ref.read(userProvider);
                //     final imageInBase64 =
                //         base64Encode(File(image.path).readAsBytesSync());

                //     final newProfile = await updateUserProfilePicture(
                //       id: user.id,
                //       token: user.token,
                //       imageBase64: imageInBase64,
                //     );

                //     if (newProfile != null) {
                //       await userFuture.setUserProfileModel(newProfile);
                //     } else {
                //       EasyLoading.showError('Failed to update profile picture');
                //     }
                //   }
                // }
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
                        child: userImage == null ||
                                userImage == "na" ||
                                userImage.isEmpty
                            ? const Icon(Icons.person,
                                size: kDefaultPadding * 5, color: Colors.white)
                            : CachedNetworkImage(
                                imageUrl: userImage,
                                height: kDefaultPadding * 5,
                                width: kDefaultPadding * 5,
                                fit: BoxFit.cover,
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
                userName ?? "User",
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
                    children: const [
                      ListTile(
                        title: Text("Update Information"),
                        subtitle: Text("Edit your account details."),
                        leading: Icon(Icons.edit),
                      ),
                      Divider(height: 0),
                      ListTile(
                        title: Text("Create your own program"),
                        subtitle: Text("Make your own workout videos"),
                        leading: Icon(Icons.video_library),
                      ),
                      Divider(height: 0),
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
