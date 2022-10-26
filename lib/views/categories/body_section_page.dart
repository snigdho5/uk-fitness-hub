import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/programme/programme_page.dart';

class BodySectionPage extends StatelessWidget {
  final String title;
  const BodySectionPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: kDefaultPadding),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w900, color: primaryColor),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Expanded(
            child: GridView.builder(
              itemCount: _lowerBodyItems.length,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: kDefaultPadding,
                mainAxisSpacing: kDefaultPadding,
              ),
              itemBuilder: (context, index) {
                final item = _lowerBodyItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProgrammePage(),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding,
                      ),
                      child: Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(kDefaultPadding * 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                          color: Colors.white,
                          border: Border.all(color: primaryColor, width: 1)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kDefaultPadding),
                        child: Image.asset(
                          item.image,
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

class LowerBodyItem {
  final String title;
  final String image;
  LowerBodyItem({
    required this.title,
    required this.image,
  });
}

final List<LowerBodyItem> _lowerBodyItems = [
  //Glutes
  LowerBodyItem(
    title: 'Glutes',
    image: glutes,
  ), //Quadriceps
  LowerBodyItem(
    title: 'Quadriceps',
    image: quadriceps,
  ), //Hamstrings
  LowerBodyItem(
    title: 'Hamstrings',
    image: hamstrings,
  ), //Adductors
  LowerBodyItem(
    title: 'Adductors',
    image: adductors,
  ),
  //Abductors
  LowerBodyItem(
    title: 'Abductors',
    image: abductors,
  ),

  //Calves
  LowerBodyItem(
    title: 'Calves',
    image: calves,
  ),
];
