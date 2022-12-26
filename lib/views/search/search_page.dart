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

          return DefaultTabController(
            length: 5,
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: primaryColor,
                  labelColor: primaryColor,
                  isScrollable: true,
                  tabs: [
                    Tab(text: "Exercises"),
                    Tab(text: "Programmes"),
                    Tab(text: "Equipments"),
                    Tab(text: "Categories"),
                    Tab(text: "Sub Categories"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ExercisesSearchList(exercises: exercises),
                      ProgramsSearchList(programs: programmes),
                      EquipmentsSearchList(equipments: equipments),
                      CategoriesSearchList(categories: categories),
                      SubCategoriesSearchList(subCategories: subCategories),
                    ],
                  ),
                ),
              ],
            ),
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

class FilterItemModel {
  List<CategoryModel> categories;
  List<SubCategoryModel> subCategories;
  List<EquipmentModel> equipments;

  FilterItemModel({
    required this.categories,
    required this.subCategories,
    required this.equipments,
  });
}

class ExercisesSearchList extends StatefulWidget {
  final List<ExerciseModel> exercises;
  const ExercisesSearchList({
    super.key,
    required this.exercises,
  });

  @override
  State<ExercisesSearchList> createState() => _ExercisesSearchListState();
}

class _ExercisesSearchListState extends State<ExercisesSearchList> {
  final List<CategoryModel> _filterCategories = [];
  final List<SubCategoryModel> _filterSubCategories = [];
  final List<EquipmentModel> _filterEquipments = [];

  @override
  Widget build(BuildContext context) {
    final List<ExerciseModel> filteredExercises =
        widget.exercises.where((exercise) {
      if (_filterCategories.isEmpty &&
          _filterSubCategories.isEmpty &&
          _filterEquipments.isEmpty) {
        return true;
      } else {
        if (_filterCategories.isNotEmpty) {
          if (_filterCategories
              .any((element) => element.id == exercise.categoryId)) {
            return true;
          }
        }
        if (_filterSubCategories.isNotEmpty) {
          if (_filterSubCategories
              .any((element) => exercise.subcategoryIds.contains(element.id))) {
            return true;
          }
        }
        if (_filterEquipments.isNotEmpty) {
          if (_filterEquipments.any((element) =>
              exercise.equipmentIds?.contains(element.id) ?? false)) {
            return true;
          }
        }
        return false;
      }
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: [
              Text(
                "Exercises".toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: primaryColor,
                radius: 9,
                child: Center(
                  child: Text(
                    filteredExercises.length.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Tooltip(
                message: "Filter",
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.filter_list),
                  onPressed: () async {
                    final FilterItemModel? result =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchFilter(
                          item: FilterItemModel(
                            categories: _filterCategories,
                            subCategories: _filterSubCategories,
                            equipments: _filterEquipments,
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        _filterCategories.clear();
                        _filterCategories.addAll(result.categories);

                        _filterSubCategories.clear();
                        _filterSubCategories.addAll(result.subCategories);

                        _filterEquipments.clear();
                        _filterEquipments.addAll(result.equipments);
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
        Wrap(
          spacing: kDefaultPadding / 4,
          runSpacing: kDefaultPadding / 4,
          children: [
            ..._filterCategories
                .map((e) => FilterItem(
                      text: e.name,
                      onDelete: () {
                        setState(() {
                          _filterCategories.remove(e);
                        });
                      },
                    ))
                .toList(),
            ..._filterSubCategories
                .map((e) => FilterItem(
                      text: e.name,
                      onDelete: () {
                        setState(() {
                          _filterSubCategories.remove(e);
                        });
                      },
                    ))
                .toList(),
            ..._filterEquipments
                .map((e) => FilterItem(
                      text: e.name,
                      onDelete: () {
                        setState(() {
                          _filterEquipments.remove(e);
                        });
                      },
                    ))
                .toList(),
          ],
        ),
        const SizedBox(height: kDefaultPadding / 2),
        if (filteredExercises.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding * 5),
              child: Text("No results found"),
            ),
          ),
        ...filteredExercises.map(
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
      ],
    );
  }
}

//ProgramsSearchList
class ProgramsSearchList extends StatelessWidget {
  final List<ProgrammeModel> programs;
  const ProgramsSearchList({
    super.key,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    return programs.isEmpty
        ? const Center(
            child: Text("No results found"),
          )
        : ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    Text(
                      "Programmes".toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 9,
                      child: Center(
                        child: Text(
                          programs.length.toString(),
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
              ...programs.map(
                (program) {
                  return CustomListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProgramDetailsPage(programme: program)));
                    },
                    title: program.name,
                    image: program.image,
                  );
                },
              ).toList(),
            ],
          );
  }
}

class EquipmentsSearchList extends StatelessWidget {
  final List<EquipmentModel> equipments;
  const EquipmentsSearchList({
    super.key,
    required this.equipments,
  });

  @override
  Widget build(BuildContext context) {
    return equipments.isEmpty
        ? const Center(
            child: Text("No results found"),
          )
        : ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    Text(
                      "Equipments".toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.bold, color: primaryColor),
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
                          builder: (context) => ExercisesByEquipmetsListPage(
                              equipmentModel: equipment)));
                    },
                    title: equipment.name,
                    image: equipment.image,
                  );
                },
              ).toList(),
            ],
          );
  }
}

class SubCategoriesSearchList extends StatelessWidget {
  final List<SubCategoryModel> subCategories;
  const SubCategoriesSearchList({
    super.key,
    required this.subCategories,
  });

  @override
  Widget build(BuildContext context) {
    return subCategories.isEmpty
        ? const Center(
            child: Text("No results found"),
          )
        : ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    Text(
                      "Sub Categories".toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.bold, color: primaryColor),
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
                          builder: (context) =>
                              ExercisesListPage(categoryModel: subCategory)));
                    },
                    title: subCategory.name,
                    image: subCategory.image,
                  );
                },
              ).toList(),
            ],
          );
  }
}

class CategoriesSearchList extends StatelessWidget {
  final List<CategoryModel> categories;
  const CategoriesSearchList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? const Center(
            child: Text("No results found"),
          )
        : ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    Text(
                      "Categories".toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.bold, color: primaryColor),
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
                          builder: (context) =>
                              SubCategoriesPage(categoryModel: category)));
                    },
                    title: category.name,
                    image: category.image,
                  );
                },
              ).toList(),
            ],
          );
  }
}

class FilterItem extends StatelessWidget {
  final String text;
  final VoidCallback onDelete;
  const FilterItem({
    super.key,
    required this.text,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 4),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: primaryColor,
                ),
          ),
          const SizedBox(width: kDefaultPadding / 4),
          InkWell(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              size: 14,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
