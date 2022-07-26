import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/models/programme_model.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';

final userProgrammesFutureProvider =
    FutureProvider<List<ProgrammeModel>>((ref) async {
  final userProfileRef = ref.watch(userHiveProvider);
  final user = userProfileRef.getUser();

  if (user != null) {
    final url = Uri.parse(baseUrl + APIs.userProgrammes);

    final headers = {
      "Authorization": "Bearer ${user.token}",
    };

    var body = {"user_id": user.id};

    final Response response = await post(url, headers: headers, body: body);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        final items = List<ProgrammeModel>.from(
            responseData.map((x) => ProgrammeModel.fromJson(x)));
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

final builtInProgrammesFutureProvider =
    FutureProvider<List<ProgrammeModel>>((ref) async {
  final userProfileRef = ref.watch(userHiveProvider);
  final user = userProfileRef.getUser();

  if (user != null) {
    final url = Uri.parse(baseUrl + APIs.programmes);

    final headers = {
      "Authorization": "Bearer ${user.token}",
    };

    var body = {"exc_type": "admin"};

    final Response response = await post(url, headers: headers, body: body);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        final items = List<ProgrammeModel>.from(
            responseData.map((x) => ProgrammeModel.fromJson(x)));
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

class ProgrammeProvider {
  static Future<bool> addNewProgramme({
    required String token,
    required String userId,
    required String programName,
    required List<String> exerciseIds,
    required List<int> exerciseTimes,
  }) async {
    final url = Uri.parse(baseUrl + APIs.addProgramme);

    final headers = {
      "Authorization": "Bearer $token",
    };

    final body = {
      "programme_name": programName,
      "exercise_ids": ",${exerciseIds.join(",")}",
      "exercise_my_time": ",${exerciseTimes.join(",")}",
      "user_id": userId,
    };

    final Response response = await post(url, headers: headers, body: body);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        return true;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      EasyLoading.showToast(
        responseBody['message'],
        toastPosition: EasyLoadingToastPosition.bottom,
      );

      return false;
    }
  }

  //Edit Programme
  static Future<bool> editProgramme({
    required String token,
    required String userId,
    required String programName,
    required List<String> exerciseIds,
    required List<int> exerciseTimes,
    required String programmeId,
  }) async {
    final url = Uri.parse(baseUrl + APIs.editProgramme);

    final headers = {
      "Authorization": "Bearer $token",
    };

    final body = {
      "programme_name": programName,
      "exercise_ids": ",${exerciseIds.join(",")}",
      "exercise_my_time": ",${exerciseTimes.join(",")}",
      "programme_id": programmeId,
      "user_id": userId,
    };

    final Response response = await post(url, headers: headers, body: body);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        return true;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      EasyLoading.showToast(
        responseBody['message'],
        toastPosition: EasyLoadingToastPosition.bottom,
      );

      return false;
    }
  }

  //Delete Programme
  static Future<bool> deleteProgramme({
    required String token,
    required String programmeId,
  }) async {
    final url = Uri.parse(baseUrl + APIs.deleteProgramme);

    final headers = {
      "Authorization": "Bearer $token",
    };

    final body = {
      "programme_id": programmeId,
    };

    final Response response = await post(url, headers: headers, body: body);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        return true;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      EasyLoading.showToast(
        responseBody['message'],
        toastPosition: EasyLoadingToastPosition.bottom,
      );

      return false;
    }
  }
}
