import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/providers/progress_provider.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
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
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: kDefaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: Text(
                "Your progress bar chart for this month",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: primaryColor),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            const FLChartSection(),
          ],
        ),
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

class FLChartSection extends ConsumerWidget {
  const FLChartSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final progressRef = ref.watch(progressProvider);

    return progressRef.when(
      data: (data) {
        return data.isEmpty
            ? const SizedBox()
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: BarChart(mainBarData(context, data)),
                  ),
                ],
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        print(error);
        print(stack);
        return const Text("Something went wrong!");
      },
    );
  }
}

BarChartData mainBarData(context, List<ProgressMonthPercentageModel> data) {
  return BarChartData(
    titlesData: FlTitlesData(
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return getTitles(value, meta, context);
          },
          reservedSize: 38,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),
    borderData: FlBorderData(show: false),
    barGroups: showingGroups(data, context),
    gridData: FlGridData(show: false),
  );
}

Widget getTitles(
  double value,
  TitleMeta meta,
  BuildContext context,
) {
  final style = Theme.of(context)
      .textTheme
      .bodySmall!
      .copyWith(fontWeight: FontWeight.bold);
  String text;
  switch (value.toInt()) {
    case 0:
      text = "Jan";
      break;
    case 1:
      text = "Feb";
      break;
    case 2:
      text = "Mar";
      break;
    case 3:
      text = "Apr";
      break;
    case 4:
      text = "May";
      break;
    case 5:
      text = "Jun";
      break;
    case 6:
      text = "Jul";
      break;
    case 7:
      text = "Aug";
      break;
    case 8:
      text = "Sep";
      break;
    case 9:
      text = "Oct";
      break;
    case 10:
      text = "Nov";
      break;
    case 11:
      text = "Dec";
      break;
    default:
      text = "";
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8,
    child: Text(text, style: style),
  );
}

BarChartGroupData makeGroupData(
  BuildContext context,
  int x,
  double y, {
  double width = 14,
  List<int> showTooltips = const [],
}) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        width: width,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(60)
          ],
        ),
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          toY: 100,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
      ),
    ],
    showingTooltipIndicators: showTooltips,
  );
}

List<BarChartGroupData> showingGroups(
    List<ProgressMonthPercentageModel> data, BuildContext context) {
  return List.generate(12, (i) {
    switch (i) {
      case 0:
        return makeGroupData(context, 0, data[0].percentage);
      case 1:
        return makeGroupData(context, 1, data[1].percentage);
      case 2:
        return makeGroupData(context, 2, data[2].percentage);
      case 3:
        return makeGroupData(context, 3, data[3].percentage);
      case 4:
        return makeGroupData(context, 4, data[4].percentage);
      case 5:
        return makeGroupData(context, 5, data[5].percentage);
      case 6:
        return makeGroupData(context, 6, data[6].percentage);
      case 7:
        return makeGroupData(context, 7, data[7].percentage);
      case 8:
        return makeGroupData(context, 8, data[8].percentage);
      case 9:
        return makeGroupData(context, 9, data[9].percentage);
      case 10:
        return makeGroupData(context, 10, data[10].percentage);
      case 11:
        return makeGroupData(context, 11, data[11].percentage);
      default:
        return makeGroupData(context, 0, 0);
    }
  });
}

class ProgressDataModel {
  DateTime day;
  bool isMarked;
  ProgressDataModel({
    required this.day,
    required this.isMarked,
  });
}

class ProgressMonthPercentageModel {
  int month;
  double percentage;
  ProgressMonthPercentageModel({
    required this.month,
    required this.percentage,
  });
}

// Generate random data from 2022 to today
List<ProgressDataModel> generateRandomData() {
  List<ProgressDataModel> data = [];
  DateTime now = DateTime.now();
  DateTime startDate = DateTime(2022, 1, 1);
  int days = now.difference(startDate).inDays;
  for (int i = 0; i < days; i++) {
    DateTime day = startDate.add(Duration(days: i));
    bool isMarked = Random().nextBool();
    data.add(ProgressDataModel(day: day, isMarked: isMarked));
  }
  return data;
}
