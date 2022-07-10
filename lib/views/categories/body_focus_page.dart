import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

class BodyFocusPage extends StatelessWidget {
  const BodyFocusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Body Focus"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: kDefaultPadding),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Text(
              "Body Focus".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w900, color: primaryColor),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Expanded(
            child: GridView.builder(
              itemCount: _bodyFocusItems.length,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: kDefaultPadding / 2,
                mainAxisSpacing: kDefaultPadding / 2,
              ),
              itemBuilder: (context, index) {
                final item = _bodyFocusItems[index];
                return GridTile(
                  footer: Container(
                    margin: const EdgeInsets.only(bottom: kDefaultPadding * 2),
                    child: GridTileBar(
                      backgroundColor: primaryColor,
                      title: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultPadding),
                        color: Colors.white,
                        border: Border.all(color: primaryColor, width: 1)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kDefaultPadding),
                      child: CachedNetworkImage(
                          imageUrl: exerciseImage, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> _bodyFocusItems = [
  "Lower Body",
  "Upper Body",
  "Core",
  "Total Body",
];