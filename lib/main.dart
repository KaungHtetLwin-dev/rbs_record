import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/blood_sugar_record.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // initialize Hive Database Engine
  await Hive.initFlutter();
  Hive.registerAdapter<BloodSugarRecord>(BloodSugarRecordAdapter());
  await Hive.openBox<BloodSugarRecord>('records');

  // start the app
  runApp(const BloodSugarRecordApp());
}

class BloodSugarRecordApp extends StatefulWidget {
  const BloodSugarRecordApp({Key? key}) : super(key: key);

  @override
  State<BloodSugarRecordApp> createState() => _BloodSugarRecordAppState();
}

class _BloodSugarRecordAppState extends State<BloodSugarRecordApp> {
  

  @override
  Widget build(BuildContext context) {
    return _buildApp(context);
  }

  Widget _buildApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.black,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          primary: Colors.black,
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        )),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: Colors.cyan,
          textStyle: TextStyle(
            //fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
            .copyWith(secondary: Colors.cyan),
        primaryColor: Colors.orange,
        fontFamily: 'Padauk',
      ),
      home: HomeScreen(),
    );
  }
}
