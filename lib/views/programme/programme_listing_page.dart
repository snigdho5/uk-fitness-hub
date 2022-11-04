import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/programme/add_new_programme_page.dart';

class ProgrammeListingPage extends StatelessWidget {
  const ProgrammeListingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: customAppBar(
        context,
        title: 'Listing',
        showDefaultActionButtons: false,
        customActions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewProgrammePage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
        ),
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            for (var i = 0; i < 5; i++)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 2,
                  ),
                  title: Text(
                    'Programme $i',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.pen)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.trash)),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            const SizedBox(height: kDefaultPadding),
            Tooltip(
              message: 'Add new programme',
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewProgrammePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
