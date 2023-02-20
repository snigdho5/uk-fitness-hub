import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/categories/category_model.dart';
import 'package:ukfitnesshub/providers/category_provider.dart';
import 'package:ukfitnesshub/views/categories/exercises_list_page.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

class SubCategoriesPage extends ConsumerWidget {
  final CategoryModel categoryModel;
  const SubCategoriesPage({Key? key, required this.categoryModel})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final subCategoriesRef = ref.watch(allSubCategoriesFutureProvider);

    return Scaffold(
      appBar: customAppBar(context, title: categoryModel.name),
      bottomNavigationBar: const BottomNavBar(),
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
                  .titleLarge!
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
          //                   .titleLarge!
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
            child: subCategoriesRef.when(
              data: (data) {
                data = data
                    .where((element) => element.categoryId == categoryModel.id)
                    .toList();

                return GridView.builder(
                  itemCount: data.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: kDefaultPadding,
                    mainAxisSpacing: kDefaultPadding,
                  ),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExercisesListPage(categoryModel: item),
                          ),
                        );
                      },
                      child: GridTile(
                        footer: Container(
                          margin: const EdgeInsets.only(
                              bottom: kDefaultPadding * 1.5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 1.5,
                                vertical: kDefaultPadding / 2),
                            color: primaryColor,
                            child: Center(
                              child: Text(
                                item.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding),
                              color: Colors.white,
                              border:
                                  Border.all(color: primaryColor, width: 1)),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding),
                            child: CachedNetworkImage(
                              imageUrl: item.image ?? "",
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
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
