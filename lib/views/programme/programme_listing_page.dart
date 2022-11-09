import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/programme_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/programme/add_new_programme_page.dart';
import 'package:ukfitnesshub/views/programme/programme_details_page.dart';

class ProgrammeListingPage extends ConsumerWidget {
  final bool isBuiltIn;
  const ProgrammeListingPage({
    Key? key,
    this.isBuiltIn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final programmesRef = isBuiltIn
        ? ref.watch(builtInProgrammesFutureProvider)
        : ref.watch(userProgrammesFutureProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: customAppBar(
        context,
        title: isBuiltIn ? 'All Programmes' : 'My Programmes',
        showDefaultActionButtons: false,
        customActions: isBuiltIn
            ? null
            : [
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
                if (isBuiltIn) {
                  ref.invalidate(builtInProgrammesFutureProvider);
                } else {
                  ref.invalidate(userProgrammesFutureProvider);
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(kDefaultPadding),
                children: [
                  for (var i = 0; i < programmes.length; i++)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kDefaultPadding / 2)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2,
                        ),
                        title: Text(
                          programmes[i].name.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: programmes[i].description != null &&
                                programmes[i].description! != "na" &&
                                programmes[i].description!.isNotEmpty
                            ? Text(
                                programmes[i].description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        leading: isBuiltIn
                            ? SizedBox(
                                width: 50,
                                child: CachedNetworkImage(
                                  imageUrl: programmes[i].image ?? "",
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.info_outline),
                                ),
                              )
                            : Text("${i + 1}."),
                        minLeadingWidth: 0,
                        trailing: isBuiltIn
                            ? const Icon(
                                Icons.arrow_forward_ios,
                                color: primaryColor,
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddNewProgrammePage(
                                                  programme: programmes[i]),
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(width: kDefaultPadding / 2),
                                  InkWell(
                                    onTap: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Delete programme'),
                                                content: const Text(
                                                    'Are you sure you want to delete this programme?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text('No')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        print(programmes[i].id);

                                                        final userProfileRef =
                                                            ref.read(
                                                                userHiveProvider);
                                                        final user =
                                                            userProfileRef
                                                                .getUser();

                                                        if (user != null) {
                                                          await ProgrammeProvider
                                                              .deleteProgramme(
                                                            token: user.token,
                                                            programmeId:
                                                                programmes[i]
                                                                    .id,
                                                          ).then((value) {
                                                            if (value) {
                                                              print('deleted');
                                                              ref.invalidate(
                                                                  userProgrammesFutureProvider);
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          });
                                                        } else {
                                                          EasyLoading.showError(
                                                              'User not found');
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                ],
                                              ));
                                    },
                                    child: const Icon(CupertinoIcons.trash),
                                  ),
                                ],
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProgramDetailsPage(programme: programmes[i]),
                            ),
                          );
                        },
                      ),
                    ),
                  if (!isBuiltIn) const SizedBox(height: kDefaultPadding),
                  if (!isBuiltIn)
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
