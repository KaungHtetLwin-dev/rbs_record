import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';


import '../../models/blood_sugar_record.dart';
import '../../custom_utils.dart';
import '../input_screen.dart';

import 'views/daily_list_view.dart';
import 'views/graph_view.dart';

class GraphScreen extends StatefulWidget {
  GraphScreen({Key? key}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late PageController _pageController;

  var _title = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var portrait = height > width;

    return ValueListenableBuilder(
        valueListenable: Hive.box<BloodSugarRecord>('records').listenable(),
        builder: (context, Box<BloodSugarRecord> box, widget) {
          if (box.isEmpty) {
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              appBar: AppBar(
                title: const Text('မှတ်တမ်းမရှိပါ'),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InputScreen()));
                },
                child: Image.asset('assets/images/glucometer_add.png'),
              ),
            );
          }

          var groupedByMonthBloodSugarRecords = box.groupedByMonth();
          var lastMonth = groupedByMonthBloodSugarRecords.entries.last.key;
          //var firstMonth = groupedByMonthBloodSugarRecords.entries.first.key;

          if (_title.isEmpty) {
            _title =
                lastMonth.month.toString() + '/' + lastMonth.year.toString();
            _title = DateFormat.yMMM().format(lastMonth);
            //_pageController.dispose();
            _pageController = PageController(
                initialPage: groupedByMonthBloodSugarRecords.length - 1);
          }

          var pages = groupedByMonthBloodSugarRecords.entries.map((entry) {
            return GraphView(
              entry,
              key: UniqueKey(),
            );
          }).toList();

          var groupedByDateBloodSugarRecords = box.groupedByDate();
          var dailyListViews =
              groupedByDateBloodSugarRecords.entries.map((entry) {
            return DailyListView(UniqueKey(), entry);
          }).toList();
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            appBar: AppBar(
              title: Text(_title),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      _pageController.previousPage(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                IconButton(
                    onPressed: () {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InputScreen()));
              },
              child: Image.asset('assets/images/glucometer_add.png'),
            ),
            body: Flex(
                direction: portrait ? Axis.vertical : Axis.horizontal,
                children: [
                  //graph and labels
                  Flexible(
                    flex: portrait ? 1 : 2,
                    child: PageView(
                      controller: _pageController,
                      children: pages,
                      onPageChanged: (value) {
                        setState(() {
                          var date = groupedByMonthBloodSugarRecords.entries
                              .elementAt(value)
                              .key;
                          _title = DateFormat.yMMM().format(date);
                        });
                      },

                      //child: GraphView(),
                      // child: ValueListenableBuilder(
                      //   valueListenable:
                      //       Hive.box<BloodSugarRecord>('records').listenable(),
                      //   builder: (context, Box<BloodSugarRecord> box, widget) {

                      //     return PageView(
                      //       controller: _pageController,
                      //       children: pages,
                      //       onPageChanged: (value) {
                      //         setState(() {
                      //           var date = groupedByMonthBloodSugarRecords.entries
                      //               .elementAt(value)
                      //               .key;
                      //           _title = '${date.month}/${date.year}';
                      //         });
                      //       },
                      //     );
                      //   },
                      // ),
                    ),
                  ),

                  portrait ? Divider() : VerticalDivider(),

                  //Container for Blood Sugar List
                  Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        portrait
                            ? SizedBox()
                            : SizedBox(
                                height: 64,
                              ),
                        Column(children: [
                          ...dailyListViews,
                          SizedBox(
                            height: 64,
                          )
                        ]),
                        // Container(
                        //   child: ValueListenableBuilder(
                        //     valueListenable:
                        //         Hive.box<BloodSugarRecord>('records')
                        //             .listenable(),
                        //     builder:
                        //         (context, Box<BloodSugarRecord> box, widget) {
                        //       //Box<BloodSugarRecord>? myBox =
                        //       //  box as Box<BloodSugarRecord>;

                        //       // var x = box.groupedByDate();
                        //       // print(x.keys.toString());

                        //       if (box.isEmpty) {
                        //         SizedBox();
                        //       }

                        //       var groupedByDateBloodSugarRecords =
                        //           box.groupedByDate();

                        //       var finalWidgets = groupedByDateBloodSugarRecords
                        //           .entries
                        //           .map((entry) {
                        //         return DailyListView(UniqueKey(), entry);
                        //       }).toList();

                        //       return Column(children: [
                        //         ...finalWidgets,
                        //         SizedBox(
                        //           height: 64,
                        //         )
                        //       ]);
                        //     },
                        //   ),
                        // ),
                      ]),
                    ),
                  ),
                ]),
          );
        });
  }
}
