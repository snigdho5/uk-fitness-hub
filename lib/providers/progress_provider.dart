import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/progress/progress_page.dart';

final progressProvider =
    FutureProvider<List<ProgressMonthPercentageModel>>((ref) async {
  final userProfileRef = ref.watch(userHiveProvider);
  final user = userProfileRef.getUser();

  if (user != null) {
    final url = Uri.parse(baseUrl + APIs.progress);

    final headers = {
      "Authorization": "Bearer ${user.token}",
    };

    var body = {"user_id": user.id};

    final Response response = await post(url, headers: headers, body: body);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'] as Map<String, dynamic>;

        final List<ProgressMonthPercentageModel> items = [];

        final Map<int, double> monthPercentageMap = {};

        responseData.forEach((key, value) {
          monthPercentageMap[int.parse(key)] = value.toDouble();
        });

        for (var i = 1; i <= 12; i++) {
          final monthPercentage = monthPercentageMap[i] ?? 0.0;

          final item = ProgressMonthPercentageModel(
            month: i,
            percentage: monthPercentage,
          );

          items.add(item);
        }

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
