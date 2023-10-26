import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/categories/sub_category_model.dart';
import 'package:ukfitnesshub/providers/exercises_provider.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';
import 'package:ukfitnesshub/views/programme/exercise/exercise_details_page.dart';

class ExercisesListPage extends ConsumerWidget {
  final SubCategoryModel categoryModel;
  const ExercisesListPage({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context, ref) {
    final exercisesRef = ref.watch(allExercisesFutureProvider);

    return Scaffold(
      appBar: customAppBar(context, title: categoryModel.name),
      bottomNavigationBar: const BottomNavBar(),
      body: exercisesRef.when(
        data: (data) {
          data = data.where((element) {
            return element.subcategoryIds
                .any((element) => element.trim() == categoryModel.id);
          }).toList();

          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            itemBuilder: (context, index) {
              final exercise = data[index];

              return CustomListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailsPage(
                        exercise: exercise,
                      ),
                    ),
                  );
                },
                title: exercise.name,
                image: exercise.image,
                description: exercise.description,
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
