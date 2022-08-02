import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/user_profile_model.dart';

final userHiveProvider = ChangeNotifierProvider<UserProfileHive>((ref) {
  return UserProfileHive();
});

class UserProfileHive extends ChangeNotifier {
  Future<void> saveUser(UserProfileModel? userProfileModel) async {
    final hiveBox = Hive.box(HiveConstants.hiveBox);
    hiveBox.put(
        HiveConstants.userProfile,
        userProfileModel == null
            ? null
            : jsonEncode(userProfileModel.toJson()));

    notifyListeners();
  }

  //Remove user from hive
  Future<void> removeUser() async {
    final hiveBox = Hive.box(HiveConstants.hiveBox);
    hiveBox.delete(HiveConstants.userProfile);
    notifyListeners();
  }

  UserProfileModel? getUser() {
    final hiveBox = Hive.box(HiveConstants.hiveBox);
    final userProfile =
        hiveBox.get(HiveConstants.userProfile, defaultValue: null);
    if (userProfile == null) {
      return null;
    } else {
      return UserProfileModel.fromJson(jsonDecode(userProfile));
    }
  }
}
