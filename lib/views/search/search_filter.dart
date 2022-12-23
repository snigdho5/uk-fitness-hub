import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';

class SearchFilter extends ConsumerStatefulWidget {
  const SearchFilter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchFilterState();
}

class _SearchFilterState extends ConsumerState<SearchFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: 'Search Filter', showDefaultActionButtons: false),
    );
  }
}
