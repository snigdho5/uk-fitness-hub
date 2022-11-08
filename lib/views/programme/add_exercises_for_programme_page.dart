import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/categories/sub_category_model.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/providers/category_provider.dart';
import 'package:ukfitnesshub/providers/exercises_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';
import 'package:ukfitnesshub/views/programme/add_new_programme_page.dart';

class AddExercisesForProgrammePage extends ConsumerStatefulWidget {
  final List<ExerciseIdModel> exerciseIds;
  const AddExercisesForProgrammePage({
    Key? key,
    this.exerciseIds = const [],
  }) : super(key: key);

  @override
  ConsumerState<AddExercisesForProgrammePage> createState() =>
      _AddExercisesForProgrammePageState();
}

class _AddExercisesForProgrammePageState
    extends ConsumerState<AddExercisesForProgrammePage> {
  final List<ExerciseIdModel> _exerciseIds = [];

  @override
  void initState() {
    _exerciseIds.addAll(widget.exerciseIds);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subCategoriesRef = ref.watch(allSubCategoriesFutureProvider);
    final allExercisesRef = ref.watch(allExercisesFutureProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _exerciseIds);
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: customAppBar(
          context,
          title: 'Add Exercises',
          showDefaultActionButtons: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
          ),
          child: subCategoriesRef.when(
            data: (subCategories) {
              return allExercisesRef.when(
                data: (allExercises) {
                  final List<SelectionItem> items = [];

                  for (var i = 0; i < subCategories.length; i++) {
                    final subCategory = subCategories[i];
                    final exercises = allExercises
                        .where((exercise) =>
                            exercise.subcategoryIds.contains(subCategory.id))
                        .toList();

                    items.add(SelectionItem(
                      subCategory: subCategory,
                      exercises: exercises,
                    ));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: AddExercisesBody(
                          selectedExerciseIds: _exerciseIds,
                          items: items,
                          onSelectionChanged: (model) async {
                            if (_exerciseIds
                                .any((element) => element.id == model.id)) {
                              _exerciseIds.removeWhere(
                                  (element) => element.id == model.id);
                            } else {
                              print("Adding");

                              final ExerciseIdModel? result =
                                  await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return ExercisePopupWidget(exercise: model);
                                },
                              );

                              if (result != null) {
                                _exerciseIds.add(result);
                              }
                            }

                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: CustomButton(
                            text: 'Save',
                            onPressed: () {
                              Navigator.pop(context, _exerciseIds);
                            }),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text(error.toString()),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => const Center(
              child: Text('Something went wrong'),
            ),
          ),
        ),
      ),
    );
  }
}

class AddExercisesBody extends StatelessWidget {
  final List<ExerciseIdModel> selectedExerciseIds;
  final List<SelectionItem> items;
  final Function(ExerciseModel model) onSelectionChanged;
  const AddExercisesBody({
    Key? key,
    required this.selectedExerciseIds,
    required this.items,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: items.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.black87,
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              tabs: items
                  .map(
                    (item) => Text(item.subCategory.name),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: items
                  .map(
                    (item) => ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: item.exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = item.exercises[index];
                        final isSelected = selectedExerciseIds
                            .any((element) => element.id == exercise.id);

                        return Card(
                          elevation: 0,
                          child: ListTile(
                            title: Text(
                              exercise.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            leading: SizedBox(
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl: exercise.image ?? "",
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_box_outlined,
                                    color: primaryColor,
                                  )
                                : const Icon(
                                    Icons.check_box_outline_blank,
                                    color: primaryColor,
                                  ),
                            onTap: () {
                              onSelectionChanged(exercise);
                            },
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ExercisePopupWidget extends StatefulWidget {
  final ExerciseModel exercise;
  const ExercisePopupWidget({super.key, required this.exercise});

  @override
  State<ExercisePopupWidget> createState() => _ExercisePopupWidgetState();
}

class _ExercisePopupWidgetState extends State<ExercisePopupWidget> {
  late int _defaultTime;

  int maxTime = 600;
  int minTime = 10;

  @override
  void initState() {
    _defaultTime = int.tryParse(widget.exercise.defaultTime) ?? 30;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String durationString = DateFormat('mm:ss')
        .format(DateTime(0).add(Duration(seconds: _defaultTime)));

    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.exercise.name,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPadding),
          SizedBox(
            height: 200,
            child: CachedNetworkImage(
              imageUrl: widget.exercise.image ?? "",
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Text(
            widget.exercise.description ?? "",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: kDefaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Duration: "),

              //Show duration as 02:10 min:sec
              Text(durationString,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          Slider(
              value: _defaultTime.toDouble(),
              min: minTime.toDouble(),
              max: maxTime.toDouble(),
              divisions: (maxTime - minTime) ~/ 5,
              onChanged: (value) {
                setState(() {
                  _defaultTime = value.toInt();
                });
              }),
          const SizedBox(height: kDefaultPadding),
          CustomButton(
            text: 'Add',
            onPressed: () {
              ExerciseIdModel exerciseIdModel = ExerciseIdModel(
                id: widget.exercise.id,
                time: _defaultTime,
              );
              Navigator.pop(context, exerciseIdModel);
            },
          ),
        ],
      ),
    );
  }
}

class SelectionItem {
  SubCategoryModel subCategory;
  List<ExerciseModel> exercises;
  SelectionItem({
    required this.subCategory,
    required this.exercises,
  });
}
