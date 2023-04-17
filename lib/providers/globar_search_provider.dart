import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/models/categories/category_model.dart';
import 'package:ukfitnesshub/models/categories/sub_category_model.dart';
import 'package:ukfitnesshub/models/equipment_model.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/models/programme_model.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';

class GlobalSearchItems {
  List<CategoryModel> categories;
  List<SubCategoryModel> subCategories;
  List<ExerciseModel> exercises;
  List<ProgrammeModel> programmes;
  List<EquipmentModel> equipments;
  GlobalSearchItems({
    required this.categories,
    required this.subCategories,
    required this.exercises,
    required this.programmes,
    required this.equipments,
  });
}

final globalSearchProvider = FutureProvider.family
    .autoDispose<GlobalSearchItems?, String>((ref, query) async {
  final userProfileRef = ref.read(userHiveProvider);
  final user = userProfileRef.getUser();

  if (user != null && query.isNotEmpty) {
    List<CategoryModel> categories = [];
    List<SubCategoryModel> subCategories = [];
    List<ExerciseModel> exercises = [];
    List<ProgrammeModel> programmes = [];
    List<EquipmentModel> equipments = [];

    final url = Uri.parse(baseUrl + APIs.globalSearch);

    final headers = {
      "Authorization": "Bearer ${user.token}",
    };

    for (var type in _types) {
      final body = {"search": query, "type": type};

      final Response response = await post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        try {
          final responseStatus = responseBody["respdata"]["status"];

          if (responseStatus == "1") {
            final responseData = responseBody["respdata"]["data"];

            if (type == "category") {
              final items = List<CategoryModel>.from(
                  responseData.map((x) => CategoryModel.fromJson(x)));

              categories = items;
            } else if (type == "subcategory") {
              final items = List<SubCategoryModel>.from(
                  responseData.map((x) => SubCategoryModel.fromJson(x)));

              subCategories = items;
            } else if (type == "exercise") {
              final items = List<ExerciseModel>.from(
                  responseData.map((x) => ExerciseModel.fromJson(x)));

              exercises = items;
            } else if (type == "program") {
              final items = List<ProgrammeModel>.from(
                  responseData.map((x) => ProgrammeModel.fromJson(x)));

              programmes = items;
            } else if (type == "equipment") {
              final items = List<EquipmentModel>.from(
                  responseData.map((x) => EquipmentModel.fromJson(x)));

              equipments = items;
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }

    GlobalSearchItems items = GlobalSearchItems(
      categories: categories,
      subCategories: subCategories,
      exercises: exercises,
      programmes: programmes,
      equipments: equipments,
    );

    return items;
  } else {
    return null;
  }
});

List<String> _types = [
  "category",
  "subcategory",
  "equipment",
  "exercise",
  "program"
];
