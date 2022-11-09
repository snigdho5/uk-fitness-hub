import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/category_provider.dart';
import 'package:ukfitnesshub/views/categories/body_focus_page.dart';
import 'package:ukfitnesshub/views/categories/subcategories_page.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/home/online_training_form_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final categoriesRef = ref.watch(categoriesFutureProvider);

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
              child: const CategoryItem(
                image: bodyFocus,
                title: "Body Focus",
                subtitle: "Focus on a specific body part",
              ),
            ),
            categoriesRef.when(
              data: (data) {
                if (data.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  if (data.any((element) =>
                      element.name.toLowerCase() == "rehabilitation")) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: kDefaultPadding),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SubCategoriesPage(
                                  categoryModel: data.firstWhere((element) =>
                                      element.name.toLowerCase() ==
                                      "rehabilitation"),
                                ),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            image: rehabitation,
                            title: "Rehabilitation",
                            subtitle: "Rehabilitation exercises",
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }
              },
              error: (error, stackTrace) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: kDefaultPadding),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OnlineTrainingFormPage()));
              },
              child: const CategoryItem(
                image: training,
                title: "Online Training with Travis",
                subtitle: "Get in touch with Travis",
              ),
            ),
            const SizedBox(height: kDefaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String image, title, subtitle;
  const CategoryItem({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
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
              "$subtitle >>",
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
