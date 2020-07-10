import 'package:intl/intl.dart';

class DateFormatter {
  static String dateToString(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static DateTime stringToDate(String date) {
    return DateFormat.yMMMd().parse(date);
  }
}