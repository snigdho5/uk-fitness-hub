import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/programme_model.dart';
import 'package:ukfitnesshub/providers/exercises_provider.dart';
import 'package:ukfitnesshub/providers/programme_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/custom_text_field.dart';
import 'package:ukfitnesshub/views/programme/add_exercises_for_programme_page.dart';

class AddNewProgrammePage extends ConsumerStatefulWidget {
  final ProgrammeModel? programme;
  const AddNewProgrammePage({
    Key? key,
    this.programme,
  }) : super(key: key);

  @override
  ConsumerState<AddNewProgrammePage> createState() =>
      _AddNewProgrammePageState();
}

class _AddNewProgrammePageState extends ConsumerState<AddNewProgrammePage> {
  String? _programmeName;
  final TextEditingController _programmeNameController =
      TextEditingController();

  List<String> _exerciseIds = [];

  @override
  void initState() {
    if (widget.programme != null) {
      _programmeName = widget.programme!.name;
      _programmeNameController.text = _programmeName!;
      _exerciseIds = widget.programme!.exerciseIds;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allExercisesRef = ref.watch(allExercisesFutureProvider);

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('You will lose all the changes!'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes')),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: customAppBar(context,
            title:
                widget.programme == null ? 'Add Programme' : 'Edit Programme',
            showDefaultActionButtons: false,
            customActions: [
              Tooltip(
                message: 'Add Exercises',
                child: IconButton(
                    onPressed: () async {
                      final List<String>? data = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExercisesForProgrammePage(
                              exerciseIds: _exerciseIds),
                        ),
                      );

                      if (data != null) {
                        setState(() {
                          _exerciseIds = data;
                        });
                      }
                    },
                    icon: const Icon(Icons.add)),
              ),
            ]),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
          ),
          child: _programmeName == null
              ? Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        controller: _programmeNameController,
                        title: 'Programme Name',
                        showTitleAsHint: true,
                      ),
                      const SizedBox(height: kDefaultPadding),
                      CustomButton(
                          text: 'Submit',
                          onPressed: () {
                            setState(() {
                              _programmeName = _programmeNameController.text;
                            });
                          }),
                    ],
                  ),
                )
              : Column(
                  children: [
                    ListTile(
                      title: Text(
                        _programmeName!,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              _programmeName = null;
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                    ),
                    allExercisesRef.when(
                      data: (exercises) {
                        exercises = exercises
                            .where(
                                (element) => _exerciseIds.contains(element.id))
                            .toList();

                        return Expanded(
                          child: Column(
                            children: [
                              exercises.isEmpty
                                  ? Expanded(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Add Exercises',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            const SizedBox(height: 10),
                                            Tooltip(
                                              message: 'Add Exercises',
                                              child: IconButton(
                                                  onPressed: () async {
                                                    final List<String>? data =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddExercisesForProgrammePage(
                                                                exerciseIds:
                                                                    _exerciseIds),
                                                      ),
                                                    );

                                                    if (data != null) {
                                                      setState(() {
                                                        _exerciseIds = data;
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: ReorderableListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding / 2),
                                        itemBuilder: (context, index) {
                                          final exercise = exercises[index];
                                          return Card(
                                            elevation: 0,
                                            key: ValueKey(exercise.id),
                                            child: ListTile(
                                              title: Text(
                                                exercise.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              leading:
                                                  const Icon(Icons.drag_handle),
                                              minLeadingWidth: 16,
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _exerciseIds
                                                          .remove(exercise.id);
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ),
                                          );
                                        },
                                        itemCount: exercises.length,
                                        onReorder: (oldIndex, newIndex) {
                                          setState(() {
                                            if (newIndex > oldIndex) {
                                              newIndex -= 1;
                                            }
                                            final exercise =
                                                exercises.removeAt(oldIndex);
                                            exercises.insert(
                                                newIndex, exercise);
                                          });
                                        },
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(kDefaultPadding),
                                child: CustomButton(
                                  onPressed: () async {
                                    if (_exerciseIds.isEmpty) {
                                      EasyLoading.showInfo(
                                          'Add atleast 1 exercises');
                                    } else {
                                      final userProfileRef =
                                          ref.read(userHiveProvider);
                                      final user = userProfileRef.getUser();
                                      EasyLoading.show(status: 'Saving...');
                                      if (user != null) {
                                        if (widget.programme == null) {
                                          await ProgrammeProvider
                                              .addNewProgramme(
                                            token: user.token,
                                            programName: _programmeName!,
                                            exerciseIds: _exerciseIds,
                                          ).then((value) {
                                            if (value) {
                                              EasyLoading.showSuccess(
                                                  'Programme Added');
                                              ref.invalidate(
                                                  programmesFutureProvider);
                                              Navigator.pop(context);
                                            }
                                          });
                                        } else {
                                          await ProgrammeProvider.editProgramme(
                                            token: user.token,
                                            programName: _programmeName!,
                                            exerciseIds: _exerciseIds,
                                            programmeId: widget.programme!.id,
                                          ).then((value) {
                                            if (value) {
                                              EasyLoading.showSuccess(
                                                  'Programme Updated');
                                              ref.invalidate(
                                                  programmesFutureProvider);
                                              Navigator.pop(context);
                                            }
                                          });
                                        }
                                      } else {
                                        EasyLoading.showError('User not found');
                                      }
                                    }
                                  },
                                  text: 'Save Programme',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text(error.toString()),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
