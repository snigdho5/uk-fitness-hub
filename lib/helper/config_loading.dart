import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorColor = Colors.white
    ..backgroundColor = Colors.black54
    ..maskColor = Colors.black54
    ..textColor = Colors.white
    ..contentPadding = const EdgeInsets.symmetric(vertical: 24, horizontal: 28)
    ..indicatorSize = 30
    ..radius = 10
    ..boxShadow = const <BoxShadow>[
      BoxShadow(
        color: Colors.black45,
        offset: Offset(0, 0),
        blurRadius: 10,
      ),
    ]
    ..displayDuration = const Duration(milliseconds: 3500)
    ..dismissOnTap = true;
}
