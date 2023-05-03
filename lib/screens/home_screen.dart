import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rbs_record_flutter_mockup/models/blood_sugar_record.dart';

import 'edible_screen.dart';
import 'graph_screen/graph_screen.dart';
import 'he_screen.dart';
import 'input_screen.dart';

import '../custom_utils.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //for screen layout detection
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var portrait = height > width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RAPPROT - RBS'),
        centerTitle: true,
        actions: [
          //navigate to GraphScreen
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GraphScreen()));
                },
                icon: const ImageIcon(
                    AssetImage('assets/images/line_chart.png'))),
          )
        ],
      ),
      body: Flex(
        //change layout according to screen orientation
        direction: portrait ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //info view about last day record
          Flexible(
            flex: 6,
            child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<BloodSugarRecord>('records').listenable(),
                builder: (context, Box<BloodSugarRecord> box, widget) {
                  //if there is no previous recrods

                  if (box.isEmpty) {
                    return const Center(
                      child: Text('မှတ်တမ်း မရှိပါ'),
                    );
                  }

                  var groupedByDateBloodSugarRecords = box.groupedByDate();
                  var lastDayRecords =
                      groupedByDateBloodSugarRecords.entries.toList()[0];
                  var headerString =
                      'နောက်ဆုံးမှတ်တမ်း ' + lastDayRecords.key.getDateString();

                  var tableRows = lastDayRecords.value.map((record) {
                    return TableRow(children: [
                      Text(record.type),
                      Text(record.entryTime.getTimeString()),
                      Text(record.value.toString() + ' ' + record.unit),
                      Center(
                        child: Text(
                          'တက်/ကျ',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ]);
                  }).toList();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(headerString)),
                      ),
                      Divider(),

                      Flexible(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: Table(
                              children: tableRows,
                            ),
                          ),
                        ),
                      ),
                      //for card that show data analysis
                      //temporarily disable before implementation

                      // SizedBox(
                      //   height: 16,
                      // ),
                      // //3 text lines height card
                      // Expanded(
                      //   child: Container(
                      //     //decoration: const BoxDecoration(color: Color(0x58ffb123)),
                      //     child: Center(
                      //       child: Card(
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(
                      //             left: 64,
                      //             right: 64,
                      //             top: 8,
                      //             bottom: 8,
                      //           ),
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             //crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 'ဒီတစ်ပတ် ပျှမ်းမျှ - ၁၈၂',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //               Text(
                      //                 'ယနေ့ မနေ့ကထက် 2% တက််',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //               Text(
                      //                 'အချိုမစားပါနှင့်၊ ညနေထပ်တိုင်းပါ။',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                }),
          ),

          portrait ? Divider() : VerticalDivider(),
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    child: Flex(
                      direction: portrait ? Axis.horizontal : Axis.vertical,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HEScreen()));
                                      },
                                      child: Text(
                                        'သိမှတ်ဖွယ်',
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EdibleScreen()));
                                      },
                                      child: Text(
                                        'စားလို့ရလား?',
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InputScreen()));
                              },
                              child:
                                  // Stack(
                                  //   children: [
                                  //     Center(
                                  //       child: Image.asset(
                                  //           'assets/images/glucometer.png',
                                  //           fit: BoxFit.contain),
                                  //     ),
                                  //     Align(
                                  //       alignment: Alignment.bottomCenter,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           'ဆီးချို တိုင်းရန်',
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),

                                  // alternate layout for 'ဆီးချိုတိုင်းရန်' button

                                  Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Image.asset(
                                        'assets/images/glucometer.png',
                                        fit: BoxFit.contain),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        'ဆီးချို တိုင်းရန်',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //Container for Ads
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Color(0xff56ccf2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
