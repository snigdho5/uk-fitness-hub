import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/categories/category_model.dart';
import 'package:ukfitnesshub/models/categories/sub_category_model.dart';
import 'package:ukfitnesshub/models/equipment_model.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/models/programme_model.dart';
import 'package:ukfitnesshub/providers/globar_search_provider.dart';
import 'package:ukfitnesshub/views/categories/exercises_by_equiment_page.dart';
import 'package:ukfitnesshub/views/categories/exercises_list_page.dart';
import 'package:ukfitnesshub/views/categories/subcategories_page.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/programme/exercise/exercise_details_page.dart';
import 'package:ukfitnesshub/views/programme/programme_details_page.dart';
import 'package:ukfitnesshub/views/home/home_page.dart';
import 'package:ukfitnesshub/views/search/search_filter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: customAppBar(
        context,
        title: "",
        showDefaultActionButtons: false,
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: CupertinoTextField(
                controller: _searchController,
                clearButtonMode: OverlayVisibilityMode.editing,
                autofocus: true,
                placeholder: "Search",
                suffixMode: OverlayVisibilityMode.editing,
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.search, color: primaryColor),
                ),
                suffix: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(CupertinoIcons.clear_circled_solid,
                        color: Colors.grey, size: 16),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              ),
            ),
            CupertinoButton(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {});
              },
              child: const Icon(CupertinoIcons.search, color: Colors.white),
            )
          ],
        ),
      ),
      body: SearchResultBody(searchQuery: _searchController.text),
    );
  }
}

class SearchResultBody extends ConsumerWidget {
  final String searchQuery;
  const SearchResultBody({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultRef = ref.watch(globalSearchProvider(searchQuery));
    return searchResultRef.when(
      data: (data) {
        if (data == null) {
          return const Center(
            child: Text("No results found"),
          );
        } else {
          List<CategoryModel> categories = data.categories;
          List<SubCategoryModel> subCategories = data.subCategories;
          List<ExerciseModel> exercises = data.exercises;
          List<EquipmentModel> equipments = data.equipments;
          List<ProgrammeModel> programmes = data.programmes;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Search Results",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                subtitle: Text(
                  "Found ${categories.length + subCategories.length + exercises.length + equipments.length + programmes.length} results",
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SearchFilter()));
                  },
                  child: const Icon(
                    Icons.filter_alt_outlined,
                    color: primaryColor,
                  ),
                ),
              ),
              const Divider(height: 0),
              const SizedBox(height: kDefaultPadding),
              if (programmes.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          Text(
                            "Programmes".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 9,
                            child: Center(
                              child: Text(
                                programmes.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    ...programmes.map(
                      (programme) {
                        return CustomListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProgramDetailsPage(programme: programme)));
                          },
                          title: programme.name,
                          image: programme.image,
                        );
                      },
                    ).toList(),
                    const SizedBox(height: kDefaultPadding * 2),
                  ],
                ),
              if (categories.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          Text(
                            "Categories".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 9,
                            child: Center(
                              child: Text(
                                categories.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    ...categories.map(
                      (category) {
                        return CustomListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SubCategoriesPage(
                                    categoryModel: category)));
                          },
                          title: category.name,
                          image: category.image,
                        );
                      },
                    ).toList(),
                    const SizedBox(height: kDefaultPadding * 2),
                  ],
                ),
              if (subCategories.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          Text(
                            "Sub Categories".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 9,
                            child: Center(
                              child: Text(
                                subCategories.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    ...subCategories.map(
                      (subCategory) {
                        return CustomListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ExercisesListPage(
                                    categoryModel: subCategory)));
                          },
                          title: subCategory.name,
                          image: subCategory.image,
                        );
                      },
                    ).toList(),
                    const SizedBox(height: kDefaultPadding * 2),
                  ],
                ),
              if (exercises.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          Text(
                            "Exercises".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 9,
                            child: Center(
                              child: Text(
                                exercises.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    ...exercises.map(
                      (exercise) {
                        return CustomListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ExerciseDetailsPage(exercise: exercise)));
                          },
                          title: exercise.name,
                          image: exercise.image,
                        );
                      },
                    ).toList(),
                    const SizedBox(height: kDefaultPadding * 2),
                  ],
                ),
              if (equipments.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          Text(
                            "Equipments".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 9,
                            child: Center(
                              child: Text(
                                equipments.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    ...equipments.map(
                      (equipment) {
                        return CustomListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ExercisesByEquipmetsListPage(
                                        equipmentModel: equipment)));
                          },
                          title: equipment.name,
                          image: equipment.image,
                        );
                      },
                    ).toList(),
                    const SizedBox(height: kDefaultPadding),
                  ],
                ),
            ],
          );
        }
      },
      error: (error, stackTrace) => const Center(
        child: Text("No results found"),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
