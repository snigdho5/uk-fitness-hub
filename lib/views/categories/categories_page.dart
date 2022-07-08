// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Categories"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: kDefaultPadding),
            Text(
              "Categories".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w900, color: primaryColor),
            ),
            const SizedBox(height: kDefaultPadding),
            const CategoryItem(image: workout, title: "Body Focus"),
            const SizedBox(height: kDefaultPadding),
            const CategoryItem(image: training, title: "Training Type"),
            const SizedBox(height: kDefaultPadding),
            const CategoryItem(image: equipment, title: "Equipment"),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String image, title;
  const CategoryItem({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        border: Border.all(color: primaryColor),
        color: Colors.white,
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              "Update Information >>",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
