import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/categories/category_model.dart';
import 'package:ukfitnesshub/models/categories/sub_category_model.dart';
import 'package:ukfitnesshub/providers/category_provider.dart';
import 'package:ukfitnesshub/providers/exercises_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/programme/exercise/exercise_details_page.dart';

class ExercisesListPage extends ConsumerWidget {
  final SubCategoryModel categoryModel;
  const ExercisesListPage({Key? key, required this.categoryModel})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final exercisesRef = ref.watch(allExercisesFutureProvider);

    return Scaffold(
      appBar: customAppBar(context,
          title: categoryModel.name, showDefaultActionButtons: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: kDefaultPadding),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Text(
              categoryModel.name.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w900, color: primaryColor),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          // Expanded(
          //   child: GridView.builder(
          //     itemCount: _lowerBodyItems.length,
          //     padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          //     shrinkWrap: true,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 1,
          //       crossAxisSpacing: kDefaultPadding,
          //       mainAxisSpacing: kDefaultPadding,
          //     ),
          //     itemBuilder: (context, index) {
          //       final item = _lowerBodyItems[index];
          //       return GestureDetector(
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => const ExerciseDetailsPage(),
          //             ),
          //           );
          //         },
          //         child: GridTile(
          //           footer: Padding(
          //             padding: const EdgeInsets.symmetric(
          //               vertical: kDefaultPadding,
          //             ),
          //             child: Text(
          //               item.title,
          //               textAlign: TextAlign.center,
          //               style: Theme.of(context)
          //                   .textTheme
          //                   .headline6!
          //                   .copyWith(fontWeight: FontWeight.w900),
          //             ),
          //           ),
          //           child: Container(
          //             padding: const EdgeInsets.all(kDefaultPadding * 3),
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(kDefaultPadding),
          //                 color: Colors.white,
          //                 border: Border.all(color: primaryColor, width: 1)),
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.circular(kDefaultPadding),
          //               child: Image.asset(
          //                 item.image,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: exercisesRef.when(
              data: (data) {
                data = data.where((element) {
                  return element.subcategoryIds
                      .any((element) => element.trim() == categoryModel.id);
                }).toList();

                return ListView.builder(
                  itemCount: data.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final exercise = data[index];

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
                            placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                        ),
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
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
