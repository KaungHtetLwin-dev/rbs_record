import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/blood_sugar_record.dart';
import '../../../custom_utils.dart';

class GraphView extends StatefulWidget {
  MapEntry<DateTime, List<BloodSugarRecord>> _monthlyData;

  GraphView(MapEntry<DateTime, List<BloodSugarRecord>> this._monthlyData,
      {Key? key})
      : super(key: key);

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  var _unit = 'mmol/L';
  var _selections = [false, false, false];
  static const _selectedALL = 0;
  static const _selectedFBS = 1;
  static const _selected2HPP = 2;

  @override
  void initState() {
    super.initState();
    _selections[_selectedALL] = true;
  }

  @override
  Widget build(BuildContext context) {
    List<BloodSugarRecord> records = [];

    //filter records
    switch (_selections.indexOf(true)) {
      case _selectedALL:
        records = widget._monthlyData.value;
        break;

      case _selectedFBS:
        records = widget._monthlyData.value
            .where((element) => element.type == BloodSugarType.fasting)
            .toList();

        break;
      case _selected2HPP:
        records = widget._monthlyData.value
            .where((element) =>
                element.type == BloodSugarType.afterDinner ||
                element.type == BloodSugarType.afterLunch)
            .toList();

        break;
    }

    //create plot data the point for the given month
    var scatterSpots = records.map((record) {
      return ScatterSpot(
        record.entryTime.day.toDouble(),
        _unit == 'mmol/L' ? record.mmolValue : record.mgValue,
        color: Colors.cyan,
      );
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ToggleButtons(
                children: [Text('ALL'), Text('FBS'), Text('2HPP')],
                isSelected: _selections,
                onPressed: (index) {
                  setState(() {
                    _selections =
                        _selections.map((selection) => false).toList();
                    _selections[index] = true;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_unit == 'mmol/L') {
                        _unit = 'mg/dL';
                      } else {
                        _unit = 'mmol/L';
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_unit),
                      Icon(Icons.change_circle),
                    ],
                  )),
            ],
          ),
        ),
        //Container for Blood Sugar Graph
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 24, bottom: 24),
            child: ScatterChart(ScatterChartData(
              scatterTouchData: ScatterTouchData(enabled: false),
              scatterSpots: scatterSpots,
              gridData: FlGridData(
                  show: true, drawHorizontalLine: true, drawVerticalLine: true),
              minX: 0,
              maxX: DateUtils.getDaysInMonth(widget._monthlyData.key.year,
                      widget._monthlyData.key.month)
                  .toDouble(),
              maxY: _unit == 'mmol/L' ? 30 : 600,
              minY: 0,
            )),
          ),
        ),
      ],
    );
  }
}
