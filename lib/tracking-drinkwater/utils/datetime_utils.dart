import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static List<DateTime> getSartAndEndDayOfWeek() {
    DateTime now = DateTime.now();
    DateTime start = now.subtract(Duration(days: now.weekday - 1));
    DateTime end = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

    return [start, end];
  }

  static String dateTimeString(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static bool isToday(DateTime dateTime) {
    DateTime now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
    int diff =
        dateTime.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (diff == 0) return true;
    return false;
  }

  static String nameOfDay(DateTime dateTime) =>
      DateFormat('E').format(dateTime);

  static bool compareYMD(DateTime dateTime1, DateTime dateTime2) {
    dateTime1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    dateTime2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    return dateTime1 == dateTime2;
  }

  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String timeTo12HourFormatString(TimeOfDay time) {
    return '${time.hourOfPeriod}:${time.minute.toString().length == 1 ? "0${time.minute.toString()}" : time.minute} ${time.period.name.toUpperCase()}';
  }
}
