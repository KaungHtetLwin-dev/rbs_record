import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './models/blood_sugar_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

// define custom extensions methods for DateTime object
// to be used in Redering Widgets
// not for data storage
extension ConvertString on DateTime {
  // returns Date only String from DateTime object
  // in "day/month/year" format
  String getDateString() {
    return '$day/$month/$year';
  }

  // returns Time only String from DateTime object
  // in 00:00 AM or 00:00 PM format
  String getTimeString() {
    var amPm = this.hour > 12 ? 'PM' : 'AM';
    var hour = this.hour % 12;
    var minute = this.minute;
    return hour.toString().padLeft(2, '0') +
        ':' +
        minute.toString().padLeft(2, '0') +
        ' ' +
        amPm;
  }

  String getMonthYearStrng() {
    return DateFormat.yMMM().format(this);
  }
}

// define custom extension methods for TimeOfDay object
// from material library
// to be used in Redering Widgets
// not for data storage
extension TimeOfDayToString on TimeOfDay {
  // returns Time only String from TimeOfDay object
  // in 00:00 AM or 00:00 PM format
  String getTimeString() {
    var amPm = this.hour > 12 ? 'PM' : 'AM';
    var hour = this.hour % 12;
    var minute = this.minute;
    return hour.toString().padLeft(2, '0') +
        ':' +
        minute.toString().padLeft(2, '0') +
        ' ' +
        amPm;
  }
}

extension GroupedBy on Box<BloodSugarRecord> {
  SplayTreeMap<DateTime, List<BloodSugarRecord>> groupedByDate() {
    //var result = Map<String, List<BloodSugarRecord>>();

    var result = SplayTreeMap<DateTime, List<BloodSugarRecord>>(
        //reversed sort order for DateTime
        (a, b) => b.compareTo(a));
    for (var i = 0; i < length; i++) {
      var record = getAt(i);
      var date = DateTime(
          record!.entryTime.year, record.entryTime.month, record.entryTime.day);

      //var date = record!.entryTime.getDateString();
      result[date] ??= <BloodSugarRecord>[];
      //if (result[date] == null) result[date] = <BloodSugarRecord>[];
      result[date]!.add(record);
    }

    //sort daily records by entryTime
    result.keys.forEach((key) {
      result[key]?.sort((a, b) => a.entryTime.compareTo(b.entryTime));
    });

    return result;
  }

  SplayTreeMap<DateTime, List<BloodSugarRecord>> groupedByMonth() {
    var result = SplayTreeMap<DateTime, List<BloodSugarRecord>>();

    for (var i = 0; i < length; i++) {
      var record = getAt(i);
      var date = DateTime(
        record!.entryTime.year,
        record.entryTime.month,
      );

      result[date] ??= <BloodSugarRecord>[];
      result[date]!.add(record);
    }

    //sort records by entryTime
    result.keys.forEach((key) =>
        result[key]?.sort((a, b) => a.entryTime.compareTo(b.entryTime)));

    return result;
  }
}
