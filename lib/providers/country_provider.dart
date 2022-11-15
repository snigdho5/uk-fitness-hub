import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ukfitnesshub/config/apis.dart';
import 'package:ukfitnesshub/models/country_model.dart';

final countriesProvider = ChangeNotifierProvider<CountryProvider>((ref) {
  return CountryProvider();
});

class CountryProvider extends ChangeNotifier {
  final List<CountryModel> _countries = [];
  List<CountryModel> get countries => _countries;

  Future<void> getCountries() async {
    final url = Uri.parse(baseUrl + APIs.countries);
    final Response response = await get(url);
    final responseBody = jsonDecode(response.body);
    final responseStatus = responseBody['status'];
    if (responseStatus == "1") {
      try {
        final responseData = responseBody['respdata'];
        final countries = List<CountryModel>.from(
            responseData.map((x) => CountryModel.fromJson(x)));
        _countries.addAll(countries);
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }
}
