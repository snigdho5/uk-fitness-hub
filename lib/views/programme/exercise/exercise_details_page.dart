import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/models/programme_model.dart';
import 'package:ukfitnesshub/providers/equipment_provider.dart';
import 'package:ukfitnesshub/views/categories/exercises_by_equiment_page.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/custom/youtube_player_widget.dart';
import 'package:ukfitnesshub/views/programme/add_exercises_for_programme_page.dart';
import 'package:ukfitnesshub/views/programme/add_new_programme_page.dart';
import 'package:ukfitnesshub/views/programme/play_program_page.dart';
import 'package:ukfitnesshub/views/programme/programme_listing_page.dart';

class ExerciseDetailsPage extends ConsumerWidget {
  final ExerciseModel exercise;
  const ExerciseDetailsPage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, ref) {
    final allEquipmentsRef = ref.watch(allEquipmentsFutureProvider);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: exercise.name,
        showDefaultActionButtons: false,
        customActions: [
          IconButton(
            tooltip: "Add to a program",
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showModalBottomSheet<ExerciseIdModel?>(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return ExercisePopupWidget(exercise: exercise);
                },
              ).then((exerciseIdModel) async {
                if (exerciseIdModel != null) {
                  await showModalBottomSheet<ProgrammeModel?>(
                    context: context,
                    builder: (context) {
                      return const MyProgrammsListToSelect();
                    },
                  ).then((programm) async {
                    if (programm != null) {
                      if (programm.exerciseIds.contains(exerciseIdModel.id)) {
                        EasyLoading.showInfo(
                            "The exercise is already there in the program!");
                        return;
                      } else {
                        EasyLoading.showToast(
                          "Exercise added to the program!",
                          toastPosition: EasyLoadingToastPosition.bottom,
                        );
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return AddNewProgrammePage(
                              programme: programm,
                              exerciseIdModel: exerciseIdModel,
                            );
                          },
                        ));
                      }
                    }
                  });
                }
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CachedNetworkImage(
                    imageUrl: exercise.image ?? "",
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                exercise.name.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: kDefaultPadding),
                            ExerciseYoutubeVideoButton(exercise: exercise),
                            const SizedBox(width: kDefaultPadding),
                          ],
                        ),
                        const SizedBox(height: kDefaultPadding),
                        Text(exercise.description ?? ""),
                        const SizedBox(height: kDefaultPadding),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (exercise.weight != "0")
                                Text(
                                  "${exercise.weight}\n${exercise.weightUnit}",
                                  textAlign: TextAlign.center,
                                ),
                              Text(
                                "${exercise.reps}\nReps",
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "${exercise.sets}\nSets",
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "${exercise.breakSeconds} secs\nHold",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: kDefaultPadding),
                        allEquipmentsRef.when(
                          data: (equipments) {
                            final width =
                                (MediaQuery.of(context).size.width / 3) -
                                    (kDefaultPadding * 2);
                            equipments = equipments
                                .where((element) =>
                                    exercise.equipmentIds
                                        ?.contains(element.id.toString()) ??
                                    false)
                                .toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Equipment Required".toUpperCase(),
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: kDefaultPadding),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (equipments.length > 3
                                        ? const Icon(Icons.arrow_back_ios,
                                            size: 16, color: primaryColor)
                                        : const SizedBox.shrink()),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: equipments.map(
                                            (e) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExercisesByEquipmetsListPage(
                                                                  equipmentModel:
                                                                      e)));
                                                },
                                                child: Container(
                                                  width: width,
                                                  height: width,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                          kDefaultPadding / 4),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            kDefaultPadding /
                                                                2),
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      kDefaultPadding / 2),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              e.image ?? "",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height:
                                                              kDefaultPadding /
                                                                  2),
                                                      Text(
                                                        e.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                              color:
                                                                  primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                    (equipments.length > 3
                                        ? const Icon(Icons.arrow_forward_ios,
                                            size: 16, color: primaryColor)
                                        : const SizedBox.shrink()),
                                  ],
                                ),
                              ],
                            );
                          },
                          loading: () => const SizedBox(),
                          error: (error, stack) => const SizedBox(),
                        ),
                        const SizedBox(height: kDefaultPadding * 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: CustomButton(
                text: "Start Exercise",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlayProgramPage(exercises: [exercise]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseYoutubeVideoButton extends StatelessWidget {
  const ExerciseYoutubeVideoButton({
    super.key,
    required this.exercise,
  });

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context) {
    return ProgrammeSpecialButton(
      icon: Icons.play_arrow,
      onPressed: () {
        if (exercise.videoUrl != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(kDefaultPadding / 2),
                alignment: Alignment.topCenter,
                backgroundColor: Colors.black,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: kDefaultPadding),
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: kDefaultPadding / 2),
                        IconButton(
                          icon: const Icon(CupertinoIcons.clear,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    YoutubePlayerWidget(videoUrl: exercise.videoUrl!),
                  ],
                ),
              );
            },
          );
        } else {
          EasyLoading.showInfo("No video available");
        }
      },
    );
  }
}

class ProgrammeSpecialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  const ProgrammeSpecialButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: primaryColor.withOpacity(0.4),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: primaryColor.withOpacity(0.7),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor,
            child: Icon(icon, color: tertiaryColor),
          ),
        ),
      ),
    );
  }
}
