import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/menu_page.dart';
import 'package:ukfitnesshub/views/profile/profile_page.dart';
import 'package:ukfitnesshub/views/search/search_page.dart';

AppBar customAppBar(
  BuildContext context, {
  required String title,
  Widget? widget,
  bool showDefaultActionButtons = true,
  List<Widget>? customActions,
}) {
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
    title: widget ??
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(logo, width: kDefaultPadding * 1.5),
            const SizedBox(width: kDefaultPadding / 2),
            Expanded(child: Text(title.toUpperCase())),
          ],
        ),
    actions: showDefaultActionButtons
        ? [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              child: Image.asset(
                search,
                width: kDefaultPadding * 1.4,
                color: tertiaryColor,
              ),
            ),
            const SizedBox(width: kDefaultPadding / 1.5),
            Image.asset(
              notification,
              width: kDefaultPadding * 1.2,
              color: tertiaryColor,
            ),
            const SizedBox(width: kDefaultPadding / 1.5),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilePage()));
              },
              child: Image.asset(
                user,
                width: kDefaultPadding * 1.2,
                color: tertiaryColor,
              ),
            ),
            const SizedBox(width: kDefaultPadding / 1.5),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MenuPage()));
              },
              child: Image.asset(
                menu,
                width: kDefaultPadding * 1.5,
                color: tertiaryColor,
              ),
            ),
            const SizedBox(width: kDefaultPadding),
          ]
        : customActions,
  );
}
