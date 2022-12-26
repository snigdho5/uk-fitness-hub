import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/categories/category_model.dart';
import 'package:ukfitnesshub/models/categories/sub_category_model.dart';
import 'package:ukfitnesshub/models/equipment_model.dart';
import 'package:ukfitnesshub/providers/category_provider.dart';
import 'package:ukfitnesshub/providers/equipment_provider.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/search/search_page.dart';

class SearchFilter extends ConsumerStatefulWidget {
  final FilterItemModel item;
  const SearchFilter({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchFilterState();
}

class _SearchFilterState extends ConsumerState<SearchFilter> {
  final List<CategoryModel> _filterCategories = [];
  final List<SubCategoryModel> _filterSubCategories = [];
  final List<EquipmentModel> _filterEquipments = [];

  @override
  void initState() {
    _filterCategories.addAll(widget.item.categories);
    _filterSubCategories.addAll(widget.item.subCategories);
    _filterEquipments.addAll(widget.item.equipments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesFutureProvider);
    final subCategories = ref.watch(allSubCategoriesFutureProvider);
    final equipments = ref.watch(allEquipmentsFutureProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(FilterItemModel(
          categories: _filterCategories,
          subCategories: _filterSubCategories,
          equipments: _filterEquipments,
        ));
        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: customAppBar(context,
              title: 'Search Filter', showDefaultActionButtons: false),
          body: Column(
            children: [
              const TabBar(
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                tabs: [
                  Tab(text: 'Categories'),
                  Tab(text: 'Sub Categories'),
                  Tab(text: 'Equipments'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    categories.when(
                      data: (categories) {
                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _filterCategories.contains(category),
                              onChanged: (value) {
                                if (value!) {
                                  _filterCategories.add(category);
                                } else {
                                  _filterCategories.remove(category);
                                }
                                setState(() {});
                              },
                              title: Text(category.name),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text(error.toString())),
                    ),
                    subCategories.when(
                      data: (subCategories) {
                        return ListView.builder(
                          itemCount: subCategories.length,
                          itemBuilder: (context, index) {
                            final subCategory = subCategories[index];
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _filterSubCategories.contains(subCategory),
                              onChanged: (value) {
                                if (value!) {
                                  _filterSubCategories.add(subCategory);
                                } else {
                                  _filterSubCategories.remove(subCategory);
                                }
                                setState(() {});
                              },
                              title: Text(subCategory.name),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text(error.toString())),
                    ),
                    equipments.when(
                      data: (equipments) {
                        return ListView.builder(
                          itemCount: equipments.length,
                          itemBuilder: (context, index) {
                            final equipment = equipments[index];
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _filterEquipments.contains(equipment),
                              onChanged: (value) {
                                if (value!) {
                                  _filterEquipments.add(equipment);
                                } else {
                                  _filterEquipments.remove(equipment);
                                }
                                setState(() {});
                              },
                              title: Text(equipment.name),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text(error.toString())),
                    ),
                  ],
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     final filterItemModel = FilterItemModel(
              //       categories: _filterCategories,
              //       subCategories: _filterSubCategories,
              //       equipments: _filterEquipments,
              //     );
              //     Navigator.of(context).pushReplacement(
              //       MaterialPageRoute(
              //         builder: (context) => SearchPage(
              //           filterItemModel: filterItemModel,
              //         ),
              //       ),
              //     );
              //   },
              //   child: Text('Apply'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
