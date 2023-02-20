import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: 'Progress'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
// ...
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                ProgressReportItem(title: "Exercises", value: "12"),
                ProgressReportItem(title: "kcal", value: "470"),
                ProgressReportItem(title: "minute", value: "21"),
              ],
            ),
          ),
          const Divider(color: primaryColor, height: 0),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("History".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: primaryColor)),
                Text("More".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: primaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressReportItem extends StatelessWidget {
  final String title;
  final String value;
  const ProgressReportItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
        Text(title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: primaryColor)),
      ],
    );
  }
}
