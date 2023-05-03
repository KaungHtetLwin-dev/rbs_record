import 'package:hive_flutter/hive_flutter.dart';

part 'blood_sugar_record.g.dart';

@HiveType(typeId: 1)
class BloodSugarRecord extends HiveObject {
  //use internally to record patient data entry time
  @HiveField(0)
  DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(0);

  @HiveField(1)
  DateTime entryTime = DateTime.fromMicrosecondsSinceEpoch(0);

  @HiveField(2)
  double value = 0.0;

  @HiveField(3)
  String unit = '';

  @HiveField(4)
  String type = '';

  @HiveField(5)
  String note = '';

  BloodSugarRecord() {}

  BloodSugarRecord.fromMap(Map<String, dynamic> data) {
    timestamp = data['timestamp'] == null
        ? DateTime.fromMicrosecondsSinceEpoch(0)
        : data['timestamp'].toDate();
    entryTime = data['entryTime'] == null
        ? DateTime.fromMicrosecondsSinceEpoch(0)
        : data['entryTime'].toDate();
    value = double.tryParse(data['value'].toString()) ?? 0;
    unit = data['unit'] ?? '';
    type = data['type'] ?? '';
    note = data['note'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'entryTime': entryTime,
      'value': value,
      'unit': unit,
      'type': type,
      'note': note,
    };
  }

  @override
  String toString() {
    return '''
      timestamp : ${timestamp.toIso8601String()}
      entryTime : ${entryTime.toIso8601String()}
      value : $value $unit
      type : $type
      note : $note
      
    ''';
  }

  double get mmolValue {
    if (unit == 'mmol/L') {
      return value;
    } else {
      //calculate mmol/L value form mg/dL value
      var result = value / 18;
      result = double.parse(result.toStringAsFixed(1));
      return result;
    }
  }

  double get mgValue {
    if (unit == 'mg/dL') {
      return value;
    } else {
      //calculate mg/dL value from mmol/L value
      var result = value * 18;
      result = result.roundToDouble();
      return result;
    }
  }
}

class BloodSugarType {
  static const random = 'ကျပန်း';
  static const fasting = 'မနက်စာ မစားမီ';
  static const beforeLunch = 'နေ့လယ်စာ မစားမီ';
  static const afterLunch = 'နေ့လယ်စာစားပြီး ၂နာရီ';
  static const beforeDinner = 'ညစာ မစားမီ';
  static const afterDinner = 'ညစာစားပြီး ၂နာရီ';
  static const bedtime = 'အိပ်ယာဝင်ချိန်';
  static const values = [
    random,
    fasting,
    beforeLunch,
    afterLunch,
    beforeDinner,
    afterDinner,
    bedtime,
  ];

  static String suggestFromDateTime(DateTime dateTime) {
    var hour = dateTime.hour;
    if (hour >= 5 && hour <= 10) {
      return fasting;
    } else if (hour >= 11 && hour <= 14) {
      return beforeLunch;
    } else if (hour > 14 && hour < 16) {
      return afterLunch;
    } else if (hour >= 17 && hour < 20) {
      return beforeDinner;
    } else if (hour >= 20 && hour < 22) {
      return afterDinner;
    } else if (hour >= 22 && hour <= 23) {
      return bedtime;
    } else {
      return random;
    }
  }
}
