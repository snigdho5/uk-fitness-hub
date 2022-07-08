import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';

AppBar customAppBar({required String title}) {
  return AppBar(
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [secondaryColor, primaryColor],
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(logo, width: kDefaultPadding * 1.5),
        const SizedBox(width: kDefaultPadding / 2),
        Expanded(child: Text(title.toUpperCase())),
      ],
    ),
    actions: [
      Image.asset(notification, width: kDefaultPadding * 1.2),
      const SizedBox(width: kDefaultPadding / 2),
      Image.asset(user, width: kDefaultPadding * 1.2),
      const SizedBox(width: kDefaultPadding / 2),
      Image.asset(menu, width: kDefaultPadding * 1.5),
      const SizedBox(width: kDefaultPadding),
    ],
  );
}
