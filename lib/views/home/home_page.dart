import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/category_provider.dart';
import 'package:ukfitnesshub/providers/user_provider.dart';
import 'package:ukfitnesshub/views/categories/subcategories_page.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/home/online_training_form_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final categoriesRef = ref.watch(categoriesFutureProvider);

    final user = ref.watch(userHiveProvider).getUser();
    DateTime now = DateTime.now();
    DateTime? trialDate = user?.trialEndDate;
    int daysLeft = trialDate?.difference(now).inDays ?? 0;
    bool isEndOfTrial = daysLeft <= 0;

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
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w900, color: primaryColor),
            ),
            if (!isEndOfTrial)
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: kDefaultPadding / 4),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "Your 14 days trial ends in ",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color:
                                Theme.of(context).textTheme.bodySmall!.color),
                        children: [
                          TextSpan(
                            text: "$daysLeft",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " days",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const BodyFocusPage()));
            //   },
            //   child: const CategoryItem(
            //     image: bodyFocus,
            //     title: "Body Focus",
            //     subtitle: "Focus on a specific body part",
            //   ),
            // ),
            const SizedBox(height: kDefaultPadding),
            categoriesRef.when(
              data: (data) {
                if (data.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return Column(
                    children: data.map((e) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SubCategoriesPage(
                                        categoryModel: e,
                                      )));
                            },
                            child: CategoryItem(
                              image: e.image ?? "",
                              title: e.name,
                              subtitle: e.description ?? "",
                            ),
                          ),
                          const SizedBox(height: kDefaultPadding),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
              error: (error, stackTrace) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OnlineTrainingFormPage()));
              },
              child: const CategoryItem(
                image: training,
                isNetWorkImage: false,
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
  final bool isNetWorkImage;
  const CategoryItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.isNetWorkImage = true,
  });

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
        image: DecorationImage(
          image: isNetWorkImage
              ? CachedNetworkImageProvider(image)
              : AssetImage(image) as ImageProvider,
          fit: BoxFit.fill,
        ),
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
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Padding(
              padding: const EdgeInsets.only(right: kDefaultPadding * 6),
              child: Text(
                "$subtitle >>",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? description;
  final String? image;
  final Widget? trailing;
  final Widget? leading;
  const CustomListTile({
    super.key,
    required this.onTap,
    this.description,
    required this.title,
    this.image,
    this.trailing,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 80),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding / 2),
            side: BorderSide(color: primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading == null
                  ? image == null
                      ? const SizedBox(width: kDefaultPadding)
                      : Container(
                          height: 80,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(kDefaultPadding / 2),
                              bottomLeft: Radius.circular(kDefaultPadding / 2),
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(image ?? ""),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                  : leading!,
              const SizedBox(width: kDefaultPadding / 2),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (description != null)
                        Text(
                          description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: kDefaultPadding / 2),
              trailing ??
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                  ),
              const SizedBox(width: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
