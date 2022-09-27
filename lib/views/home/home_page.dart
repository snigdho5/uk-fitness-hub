import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/categories/body_focus_page.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "UK Fitness Hub"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: kDefaultPadding),
            Text(
              "Main Menu".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w900, color: primaryColor),
            ),
            const SizedBox(height: kDefaultPadding),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BodyFocusPage()));
              },
              child: const CategoryItem(image: workout, title: "Body Focus"),
            ),
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
