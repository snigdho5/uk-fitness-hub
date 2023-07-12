import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/models/settings_model.dart';

final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider();
});

class SettingsProvider extends ChangeNotifier {
  SettingsModel? _settings;
  SettingsModel? get settings => _settings;

  Future<void> getSettings() async {
    final url = Uri.parse(baseUrl + APIs.settings);
    final Response response = await get(url);
    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];
    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        print(responseData);
        _settings = SettingsModel.fromJson(responseData[0]);
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }
}
