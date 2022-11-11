import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/models/equipment_model.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';

final allEquipmentsFutureProvider =
    FutureProvider<List<EquipmentModel>>((ref) async {
  final userProfileRef = ref.watch(userHiveProvider);
  final user = userProfileRef.getUser();

  if (user != null) {
    final url = Uri.parse(baseUrl + APIs.equipments);

    final headers = {
      "Authorization": "Bearer ${user.token}",
    };
    final Response response = await get(url, headers: headers);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        final items = List<EquipmentModel>.from(
            responseData.map((x) => EquipmentModel.fromJson(x)));
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
