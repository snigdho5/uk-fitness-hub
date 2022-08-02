import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/models/user_profile_model.dart';

class AuthProvider {
  static Future<UserProfileModel?> signUp(
      {required Map<String, String> data}) async {
    final url = Uri.parse(baseUrl + APIs.signUp);

    final Response response = await post(url, body: data);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];
    EasyLoading.showToast(
      responseBody['message'],
      toastPosition: EasyLoadingToastPosition.bottom,
    );
    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        final userProfileModel = UserProfileModel.fromJson(responseData);
        return userProfileModel;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<UserProfileModel?> login(
      {required Map<String, String> data}) async {
    final url = Uri.parse(baseUrl + APIs.login);

    final Response response = await post(url, body: data);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];
    EasyLoading.showToast(
      responseBody['message'],
      toastPosition: EasyLoadingToastPosition.bottom,
    );
    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        final userProfileModel = UserProfileModel.fromJson(responseData);
        return userProfileModel;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<bool> logout(
      {required String token, required String userId}) async {
    final url = Uri.parse(baseUrl + APIs.logout);

    final data = {"user_id": userId};

    final headers = {
      "Authorization": "Bearer $token",
    };

    final Response response = await post(url, body: data, headers: headers);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    print(responseBody);
    EasyLoading.showToast(
      responseBody['message'],
      toastPosition: EasyLoadingToastPosition.bottom,
    );
    if (responseStatus == "1") {
      try {
        return true;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }
}
