import 'package:intl/intl.dart';

class DateService {
  static String dateTimeToString(DateTime dateTime) {
    String month = DateService.getMonthStringFromDateTime(dateTime);
    String day = DateService.getDayStringFromDateTime(dateTime);
    String year = DateService.getYearFromDateTime(dateTime);
    String time = DateService.getHourMinutesAMPMStringFromDateTime(dateTime);

    return "$month $day, $year at $time";
  }

  static String getMonthStringFromDateTime(DateTime dateTime) => months[dateTime.month]!;
  static String getDayStringFromDateTime(DateTime dateTime) => dateTime.day.toString();
  static String getYearFromDateTime(DateTime dateTime) => dateTime.year.toString();

  static String getHourMinutesAMPMStringFromDateTime(DateTime dateTime) => DateFormat('hh:mm a').format(dateTime);

  static Map<int, String> months = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };
}
