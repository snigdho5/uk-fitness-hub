import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/programme_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';
import 'package:ukfitnesshub/views/programme/add_new_programme_page.dart';
import 'package:ukfitnesshub/views/programme/programme_details_page.dart';

class ProgramListingTabView extends StatefulWidget {
  const ProgramListingTabView({super.key});

  @override
  State<ProgramListingTabView> createState() => _ProgramListingTabViewState();
}

class _ProgramListingTabViewState extends State<ProgramListingTabView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'All Programmes',
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                labelColor: primaryColor,
                unselectedLabelColor: Colors.black87,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                unselectedLabelStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black54),
                tabs: const [
                  Tab(
                    text: 'My Programmes',
                  ),
                  Tab(
                    text: 'Admin Programmes',
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  ProgrammeListingBody(),
                  ProgrammeListingBody(isBuiltIn: true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProgrammeListingBody extends ConsumerWidget {
  final bool isBuiltIn;
  const ProgrammeListingBody({
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
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                children: [
                  for (var i = 0; i < programmes.length; i++)
                    CustomListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProgramDetailsPage(programme: programmes[i]),
                          ),
                        );
                      },
                      title: programmes[i].name.toUpperCase(),
                      description: programmes[i].description != null &&
                              programmes[i].description! != "na" &&
                              programmes[i].description!.isNotEmpty
                          ? programmes[i].description!
                          : null,
                      image: !isBuiltIn ? null : programmes[i].image,
                      leading: !isBuiltIn
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: kDefaultPadding),
                              child: Text("${i + 1}.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontWeight: FontWeight.bold)),
                            )
                          : null,
                      trailing: isBuiltIn
                          ? null
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
                                                        Navigator.pop(context),
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
                                                              programmes[i].id,
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

class MyProgrammsListToSelect extends ConsumerWidget {
  const MyProgrammsListToSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programmesRef = ref.watch(userProgrammesFutureProvider);
    return programmesRef.when(
      data: (programmes) {
        return ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            Text(
              'My Programmes',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Select a programme to add to your workout',
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(height: kDefaultPadding),
            for (var i = 0; i < programmes.length; i++)
              CustomListTile(
                onTap: () {
                  Navigator.pop(context, programmes[i]);
                },
                title: programmes[i].name.toUpperCase(),
                description: programmes[i].description != null &&
                        programmes[i].description! != "na" &&
                        programmes[i].description!.isNotEmpty
                    ? programmes[i].description!
                    : null,
                image: programmes[i].image,
                leading: Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding),
                  child: Text("${i + 1}.",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
    );
  }
}
