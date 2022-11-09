import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/models/programme_model.dart';
import 'package:ukfitnesshub/providers/exercises_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/programme/play_program_page.dart';

class ProgramDetailsPage extends ConsumerStatefulWidget {
  final ProgrammeModel programme;
  const ProgramDetailsPage({
    super.key,
    required this.programme,
  });

  @override
  ConsumerState<ProgramDetailsPage> createState() => _ProgramDetailsPageState();
}

class _ProgramDetailsPageState extends ConsumerState<ProgramDetailsPage> {
  final List<String> _exerciseIds = [];

  @override
  void initState() {
    _exerciseIds.addAll(widget.programme.exerciseIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allExercisesRef = ref.watch(allExercisesFutureProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: customAppBar(context,
          title: widget.programme.name, showDefaultActionButtons: false),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
          ),
          child: allExercisesRef.when(
            data: (e) {
              final List<ExerciseModel> exercisesList = [];

              for (var exerciseId in _exerciseIds) {
                if (e.any((element) => element.id == exerciseId)) {
                  exercisesList.add(
                    e
                        .firstWhere((element) => element.id == exerciseId)
                        .copyWith(
                          defaultTime: widget.programme
                              .exerciseTimes[_exerciseIds.indexOf(exerciseId)]
                              .toString(),
                        ),
                  );
                }
              }

              return Column(
                children: [
                  Expanded(
                    child: ReorderableListView.builder(
                      padding: const EdgeInsets.all(kDefaultPadding / 2),
                      itemBuilder: (context, index) {
                        final exercise = exercisesList[index];

                        String durationString = DateFormat('mm:ss').format(
                            DateTime(0).add(Duration(
                                seconds:
                                    int.tryParse(exercise.defaultTime) ?? 30)));

                        return Card(
                          elevation: 0,
                          key: ValueKey(exercise.id),
                          child: ListTile(
                            title: Text(
                              exercise.name.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(durationString),
                            leading: SizedBox(
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl: exercise.image ?? "",
                                placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            minLeadingWidth: 16,
                          ),
                        );
                      },
                      itemCount: exercisesList.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final String item = _exerciseIds.removeAt(oldIndex);
                          _exerciseIds.insert(newIndex, item);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: CustomButton(
                      text: 'Start'.toUpperCase(),
                      onPressed: () {
                        if (exercisesList.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayProgramPage(
                                exercises: exercisesList,
                                programName: widget.programme.name,
                              ),
                            ),
                          );
                        } else {
                          EasyLoading.showInfo('No exercises found');
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(error.toString())),
          )),
    );
  }
}
