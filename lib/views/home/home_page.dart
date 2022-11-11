import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/categories/category_model.dart';
import 'package:ukfitnesshub/models/categories/sub_category_model.dart';
import 'package:ukfitnesshub/models/equipment_model.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/models/programme_model.dart';
import 'package:ukfitnesshub/providers/category_provider.dart';
import 'package:ukfitnesshub/providers/globar_search_provider.dart';
import 'package:ukfitnesshub/views/categories/body_focus_page.dart';
import 'package:ukfitnesshub/views/categories/exercises_by_equiment_page.dart';
import 'package:ukfitnesshub/views/categories/exercises_list_page.dart';
import 'package:ukfitnesshub/views/categories/subcategories_page.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/home/online_training_form_page.dart';
import 'package:ukfitnesshub/views/programme/exercise/exercise_details_page.dart';
import 'package:ukfitnesshub/views/programme/programme_details_page.dart';

class HomePage extends ConsumerStatefulWidget {
  final bool showSearch;
  final VoidCallback onTapClear;
  const HomePage({
    Key? key,
    required this.showSearch,
    required this.onTapClear,
  }) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoriesRef = ref.watch(categoriesFutureProvider);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: "UK Fitness Hub",
        widget: widget.showSearch
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        widget.onTapClear();
                      },
                      child: const Icon(CupertinoIcons.clear,
                          color: Colors.white)),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 2),
                    ),
                  ),
                  CupertinoButton(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {});
                    },
                    child:
                        const Icon(CupertinoIcons.search, color: Colors.white),
                  )
                ],
              )
            : null,
        showDefaultActionButtons: !widget.showSearch,
      ),
      body: widget.showSearch
          ? SearchResultBody(searchQuery: _searchController.text)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: kDefaultPadding),
                  Text(
                    "Main Menu".toUpperCase(),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w900, color: primaryColor),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const BodyFocusPage()));
                    },
                    child: const CategoryItem(
                      image: bodyFocus,
                      title: "Body Focus",
                      subtitle: "Focus on a specific body part",
                    ),
                  ),
                  categoriesRef.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        if (data.any((element) =>
                            element.name.toLowerCase() == "rehabilitation")) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: kDefaultPadding),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SubCategoriesPage(
                                        categoryModel: data.firstWhere(
                                            (element) =>
                                                element.name.toLowerCase() ==
                                                "rehabilitation"),
                                      ),
                                    ),
                                  );
                                },
                                child: const CategoryItem(
                                  image: rehabitation,
                                  title: "Rehabilitation",
                                  subtitle: "Rehabilitation exercises",
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                    },
                    error: (error, stackTrace) => const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const OnlineTrainingFormPage()));
                    },
                    child: const CategoryItem(
                      image: training,
                      title: "Online Training with Travis",
                      subtitle: "Get in touch with Travis",
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                ],
              ),
            ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String image, title, subtitle;
  const CategoryItem({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        border: Border.all(color: primaryColor),
        color: Colors.white,
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              "$subtitle >>",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ],
        ),
      ),
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
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
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

class CustomListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? description;
  final String? image;
  final Widget? trailing;
  final Widget? leading;
  const CustomListTile({
    Key? key,
    required this.onTap,
    this.description,
    required this.title,
    this.image,
    this.trailing,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding / 2),
            side: BorderSide(color: primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading == null
                  ? image == null
                      ? const SizedBox(width: kDefaultPadding)
                      : Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(kDefaultPadding / 2),
                              bottomLeft: Radius.circular(kDefaultPadding / 2),
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(image ?? ""),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                  : leading!,
              const SizedBox(width: kDefaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (description != null)
                      Text(
                        description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPadding / 2),
              trailing ??
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                  ),
              const SizedBox(width: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
