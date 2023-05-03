import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/blood_sugar_record.dart';
import '../custom_utils.dart';

class InputScreen extends StatefulWidget {
  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  DateTime _dateTime = DateTime.now();
  var _unit = 'mg/dL';
  late String _bloodSugarType;
  var _showNote = false;

  final _value = TextEditingController();
  final _note = TextEditingController();
  late DateTime _date;
  late TimeOfDay _time;

  _InputScreenState() {
    var now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
    _time = TimeOfDay.fromDateTime(now);
    _autoSuggestBloodSugarType();
  }

  @override
  void dispose() {
    _value.dispose();
    _note.dispose();
    super.dispose();
  }

  // select Blood Glucose Type automatically
  // in Dropdown Menu depending on current time or
  // time based on user input
  // hour is in 24 hour format
  void _autoSuggestBloodSugarType() {
    var hour = _time.hour;
    if (hour >= 5 && hour <= 10) {
      _bloodSugarType = BloodSugarType.fasting;
    } else if (hour >= 11 && hour <= 14) {
      _bloodSugarType = BloodSugarType.beforeLunch;
    } else if (hour > 14 && hour < 16) {
      _bloodSugarType = BloodSugarType.afterLunch;
    } else if (hour >= 17 && hour < 20) {
      _bloodSugarType = BloodSugarType.beforeDinner;
    } else if (hour >= 20 && hour < 22) {
      _bloodSugarType = BloodSugarType.afterDinner;
    } else if (hour >= 22 && hour <= 23) {
      _bloodSugarType = BloodSugarType.bedtime;
    } else {
      _bloodSugarType = BloodSugarType.random;
    }
  }

  String _getSuggestionText() {
    // note for suggestion algorithm
    // RBS = > 250 mg/dL or > 13.9 mmol/L ==> Very High
    // RBS = >180 mg/dL or >10.0 mmol/L ==> High
    // RBS = 70-180 mg/dL or 3.9 - 10.0 mmol/L ==> Normal
    // RBS = < 70mg /dl or <3.9 mmol/L ==> Low
    // RBS = < 54 mg/dL or < 3.0 mmol/L ==> Very Low

    if (_unit == 'mg/dL') {
    } else {}

    return 'အနည်းငယ် တက်/ကျ နေပါသည်။';
  }

  void _showSaveRecordDialog(String value) async {
    if (value == '') {
      // TO DO
      // implement warning dialog
    }

    await showDialog<void>(
        context: context,
        builder: (_) {
          return SimpleDialog(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/glucometer.png'),
                  ),
                  Text('သင့်အဖြေ ထည့်ပြီးပါပြီ'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0x58ffb123)),
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(value + ' ' + _unit),
                          Text(_getSuggestionText()),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          //create a new Blood Sugar Record
                          BloodSugarRecord record = BloodSugarRecord()
                            ..timestamp = DateTime.now()
                            ..entryTime = _date.add(Duration(
                                hours: _time.hour, minutes: _time.minute))
                            ..value = double.tryParse(value) ?? 0.0
                            ..unit = _unit
                            ..type = _bloodSugarType
                            ..note = _note.text;
                          Hive.box<BloodSugarRecord>('records').add(record);

                          //return to Home Screen
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('အိုကေ')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          //return to Input Screen
                          Navigator.pop(context);
                        },
                        child: Text('ပြင်ဆင်ရန်')),
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DropdownButton<String>(
              //value: BloodSugarTypes[_bloodSugarType.index],
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
              alignment: AlignmentDirectional.center,
              dropdownColor: Theme.of(context).colorScheme.primary,
              value: _bloodSugarType,
              onChanged: (newValue) {
                setState(() {
                  if (newValue != null) {
                    _bloodSugarType = newValue;
                  }
                });
              },
              items: BloodSugarType.values
                  .map((value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            fontWeight: FontWeight.bold,
                          ))))
                  .toList()),
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Color(0x58ffb123)),
              child: Row(
                children: [
                  Image.asset('assets/images/glucometer.png'),
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        // DropdownButton<String>(
                        //     //value: BloodSugarTypes[_bloodSugarType.index],
                        //     value: _bloodSugarType,
                        //     onChanged: (newValue) {
                        //       setState(() {
                        //         if (newValue != null) {
                        //           _bloodSugarType = newValue;
                        //         }
                        //       });
                        //     },
                        //     items: BloodSugarType.values
                        //         .map((value) => DropdownMenuItem<String>(
                        //             value: value, child: Text(value)))
                        //         .toList()),

                        SizedBox(
                          width: 240,
                          child: TextField(
                              controller: _value,
                              onChanged: (value) {
                                setState(() {
                                  // if input number contains "."
                                  // it is interpreted as
                                  // floating point number
                                  // and change unit to mmol/L
                                  if (value.contains('.')) {
                                    _unit = 'mmol/L';
                                  } else {
                                    _unit = 'mg/dL';
                                  }
                                });
                              },
                              onSubmitted: _showSaveRecordDialog,
                              autofocus: true,
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: 'သင့်အဖြေ', suffixText: _unit)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            //Date & Time View Container
            Container(
              child: Column(
                children: [
                  // Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text('DATE & TIME'),
                  //     )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              showDatePicker(
                                //initialEntryMode: DatePickerEntryMode.input,
                                locale: Locale('en', 'GB'),
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000, 1),
                                lastDate: DateTime(2100, 1),
                              ).then((value) {
                                if (value != null) {
                                  this.setState(() {
                                    _date = value;
                                  });
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.today),
                                SizedBox(width: 8),
                                Text(_date.getDateString()),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              showTimePicker(
                                //initialEntryMode: TimePickerEntryMode.input,
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: _dateTime.hour,
                                    minute: _dateTime.minute),
                              ).then((value) {
                                //TO DO
                                if (value != null) {
                                  setState(() {
                                    _time = value;
                                    _autoSuggestBloodSugarType();
                                  });
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 8),
                                Text(_time.getTimeString()),
                              ],
                            )),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            {
                              _showSaveRecordDialog(_value.text);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'သိမ်း ရန်',
                            ),
                          )),
                      //Icon(Icons.calendar_today_rounded),
                    ],
                  ),
                  // DropdownButton<String>(
                  //     //value: BloodSugarTypes[_bloodSugarType.index],
                  //     value: _bloodSugarType,
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         if (newValue != null) {
                  //           _bloodSugarType = newValue;
                  //         }
                  //       });
                  //     },
                  //     items: BloodSugarType.values
                  //         .map((value) => DropdownMenuItem<String>(
                  //             value: value, child: Text(value)))
                  //         .toList()),

                  //note container
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _showNote = !_showNote;
                              });
                            },
                            child: Row(
                              children: [
                                _showNote
                                    ? Icon(Icons.arrow_drop_down)
                                    : Icon(Icons.play_arrow),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('မှတ်ချက်'),
                              ],
                            ),
                          ),
                        ),
                        if (_showNote)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _note,
                              maxLines: 5,
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                            ),
                          )
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       {
                  //         _showSaveRecordDialog(_value.text);
                  //       }
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text(
                  //         'သိမ်း ရန်',
                  //       ),
                  //     )),
                ],
              ),
            ),
          ],
        ));
  }
}
