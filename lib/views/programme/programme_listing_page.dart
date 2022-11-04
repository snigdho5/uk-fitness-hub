import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/programme_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/programme/add_new_programme_page.dart';

class ProgrammeListingPage extends ConsumerWidget {
  const ProgrammeListingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final programmesRef = ref.watch(programmesFutureProvider);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: customAppBar(
        context,
        title: 'Listing',
        showDefaultActionButtons: false,
        customActions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewProgrammePage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
        ),
        child: programmesRef.when(
          data: (programmes) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(programmesFutureProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(kDefaultPadding),
                children: [
                  for (var i = 0; i < programmes.length; i++)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kDefaultPadding)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2,
                        ),
                        title: Text(
                          programmes[i].name,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: programmes[i].description != null &&
                                programmes[i].description! != "na" &&
                                programmes[i].description!.isNotEmpty
                            ? Text(
                                programmes[i].description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontWeight: FontWeight.w500),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNewProgrammePage(
                                        programme: programmes[i]),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                print(programmes[i].id);

                                final userProfileRef =
                                    ref.read(userHiveProvider);
                                final user = userProfileRef.getUser();

                                if (user != null) {
                                  await ProgrammeProvider.deleteProgramme(
                                    token: user.token,
                                    programmeId: programmes[i].id,
                                  ).then((value) {
                                    if (value) {
                                      print('deleted');
                                      ref.invalidate(programmesFutureProvider);
                                    }
                                  });
                                } else {
                                  EasyLoading.showError('User not found');
                                }
                              },
                              icon: const Icon(CupertinoIcons.trash),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  const SizedBox(height: kDefaultPadding),
                  Tooltip(
                    message: 'Add new programme',
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddNewProgrammePage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(error.toString()),
          ),
        ),
      ),
    );
  }
}
