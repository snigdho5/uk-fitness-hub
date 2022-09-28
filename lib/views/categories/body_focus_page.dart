import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/categories/body_section_page.dart';
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
                crossAxisSpacing: kDefaultPadding,
                mainAxisSpacing: kDefaultPadding,
              ),
              itemBuilder: (context, index) {
                final item = _bodyFocusItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BodySectionPage(title: item),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: Container(
                      margin:
                          const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 1.5,
                            vertical: kDefaultPadding / 2),
                        color: primaryColor,
                        child: Center(
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                          ),
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
                        child: Image.asset(
                          _bodyFocusImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
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

final List<String> _bodyFocusImages = [
  lowerBody,
  upperBody,
  core,
  totalBody,
];
