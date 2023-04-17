import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ukfitnesshub/helper/url_launcher_helper.dart';
import 'package:ukfitnesshub/providers/settings_provider.dart';
import 'package:ukfitnesshub/views/custom/bottom_nav_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

//About
class About extends ConsumerWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final settings = ref.watch(settingsProvider).settings;
    return OtherPage(title: "About", htmlData: settings?.appAbout);
  }
}

class OtherPage extends StatelessWidget {
  final String title;
  final String? htmlData;
  const OtherPage({
    Key? key,
    required this.title,
    required this.htmlData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: title),
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: htmlData == null
            ? const SizedBox()
            : HtmlWidget(
                htmlData!,
                onTapUrl: (url) {
                  launchURL(url);
                  return true;
                },
              ),
      ),
    );
  }
}
