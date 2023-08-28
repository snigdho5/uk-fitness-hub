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
        print(e.toString());
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
        print(e.toString());
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

    print(responseBody.toString());
    EasyLoading.showToast(
      responseBody['message'],
      toastPosition: EasyLoadingToastPosition.bottom,
    );
    if (responseStatus == "1") {
      try {
        return true;
      } catch (e) {
        print(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }

  // Delete Account
  static Future<bool> deleteAccount(
      {required String token, required String userId}) async {
    final url = Uri.parse(baseUrl + APIs.deleteAccount);

    final data = {"user_id": userId};

    final headers = {
      "Authorization": "Bearer $token",
    };

    final Response response = await post(url, body: data, headers: headers);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    print(responseBody.toString());

    EasyLoading.showToast(
      responseBody['message'],
      toastPosition: EasyLoadingToastPosition.bottom,
    );

    if (responseStatus == "1") {
      try {
        return true;
      } catch (e) {
        print(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }

  //Change Password
  static Future<bool> changePassword(
      {required String token,
      required String userId,
      required String oldPassword,
      required String newPassword}) async {
    final url = Uri.parse(baseUrl + APIs.changePassword);

    final data = {
      "user_id": userId,
      "old_password": oldPassword,
      "new_password": newPassword
    };

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
        print(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }

  //Edit Profile
  static Future<UserProfileModel?> updateProfile(
      Map<String, String> data, String token) async {
    final url = Uri.parse(baseUrl + APIs.editProfile);

    final headers = {
      "Authorization": "Bearer $token",
    };

    final Response response = await post(url, body: data, headers: headers);

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
        print(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  //Upload Profile Image
  static Future<UserProfileModel?> uploadProfileImage(
      {required String token,
      required String userId,
      required String imageBase64}) async {
    final url = Uri.parse(baseUrl + APIs.uploadProfileImage);

    final data = {
      "user_id": userId,
      "img_base64": imageBase64,
    };

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
        final responseData = responseBody['respdata'];

        final userProfileModel = UserProfileModel.fromJson(responseData);
        return userProfileModel;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<ForgorPasswordData?> forgotPassword(String email) async {
    final url = Uri.parse(baseUrl + APIs.forgotPassword);

    final body = {"email": email};

    final Response response = await post(url, body: body);

    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];

    print(responseBody);

    EasyLoading.showToast(
      responseBody['message'],
      toastPosition: EasyLoadingToastPosition.bottom,
    );

    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];

        final otp = responseData['forget_otp'];
        final userId = responseData['_id'];

        final ForgorPasswordData forgorPasswordData =
            ForgorPasswordData(otp: otp, userId: userId);

        return forgorPasswordData;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<bool> resetPassword(
      {required String userId,
      required String otp,
      required String newPassword}) async {
    final url = Uri.parse(baseUrl + APIs.resetPassword);

    final body = {
      "user_id": userId,
      "otp": otp,
      "new_password": newPassword,
      "repeat_password": newPassword
    };

    final Response response = await post(url, body: body);

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
        print(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }
}

class ForgorPasswordData {
  String userId;
  String otp;

  ForgorPasswordData({required this.userId, required this.otp});
}
