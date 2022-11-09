import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';

class ContactWithTravisProvider {
  static Future<bool> submit({
    required String name,
    required String email,
    required String phone,
    required String maessage,
    required String userId,
    required String token,
  }) async {
    final url = Uri.parse(baseUrl + APIs.contactWithTravis);

    final headers = {
      "Authorization": "Bearer $token",
    };

    final body = {
      "name": name,
      "email": email,
      "phone": phone,
      "message": maessage,
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
}
