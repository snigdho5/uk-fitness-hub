import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';

final allExercisesFutureProvider =
    FutureProvider<List<ExerciseModel>>((ref) async {
  final userProfileRef = ref.watch(userHiveProvider);
  final user = userProfileRef.getUser();

  if (user != null) {
    final url = Uri.parse(baseUrl + APIs.allExercises);

    final headers = {
      "Authorization": "Bearer ${user.token}",
    };
    final Response response = await get(url, headers: headers);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        final items = List<ExerciseModel>.from(
            responseData.map((x) => ExerciseModel.fromJson(x)));
        return items;
      } catch (e) {
        debugPrint(e.toString());
        return [];
      }
    } else {
      EasyLoading.showToast(
        responseBody['message'],
        toastPosition: EasyLoadingToastPosition.bottom,
      );

      return [];
    }
  } else {
    return [];
  }
});

Future<bool> addExerciseRecord({
  required String userId,
  required String token,
  required String exerciseId,
  required String weight,
}) async {
  final url = Uri.parse(baseUrl + APIs.addRecord);

  final headers = {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
  };

  final Map<String, dynamic> body = {
    "user_id": userId,
    "exercise_id": exerciseId,
    "weight": int.tryParse(weight) ?? 0,
  };

  final Response response = await post(
    url,
    body: jsonEncode(body),
    headers: headers,
  );

  final responseBody = jsonDecode(response.body);
  final responseStatus = responseBody['status'];

  if (responseStatus == "1") {
    final data = responseBody['respdata'];

    debugPrint(data.toString());

    final result = data['new_record'];
    debugPrint("\n\nResult: $result");

    return result as bool;
  } else {
    EasyLoading.showToast(
      responseBody['message'],
      toastPosition: EasyLoadingToastPosition.bottom,
    );
    return false;
  }
}
