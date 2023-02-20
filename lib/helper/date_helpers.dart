import 'package:intl/intl.dart';

class DateHelpers {
  DateHelpers._();

  static String getFormattedDate(DateTime dateTime) {
    return DateFormat('MM-dd-yyyy').format(dateTime);
  }

  // return as hh:mm | dd/mm/yyyy
  static String getFormattedTime(DateTime dateTime, {bool isNewLine = false}) {
    return '${DateFormat.Hm().format(dateTime)}${isNewLine ? "\n" : ", "}${DateFormat.yMd().format(dateTime)}';
  }
}

//Time Helpers

class TimeHelpers {
  TimeHelpers._();

  static String getFormattedTime(int time) {
    final int minutes = (time / 60).floor();
    final int seconds = time % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
