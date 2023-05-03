import 'package:flutter/material.dart';
import 'package:rbs_record_flutter_mockup/models/blood_sugar_record.dart';
import '../../../custom_utils.dart';

class DailyListView extends StatefulWidget {
  MapEntry<DateTime, List<BloodSugarRecord>> _dailyEntry;

  DailyListView(Key? key, this._dailyEntry) : super(key: key);

  @override
  State<DailyListView> createState() => _DailyListViewState();
}

class _DailyListViewState extends State<DailyListView> {
  var _editable = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget._dailyEntry.key.getDateString()),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _editable = !_editable;
                      });
                    },
                    icon: _editable
                        ? const Icon(Icons.undo)
                        : const Icon(Icons.edit))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: widget._dailyEntry.value.map((record) {
                  return TableRow(children: [
                    Text(record.type),
                    Text(record.entryTime.getTimeString()),
                    Text('${record.value} ${record.unit}'),
                    const Center(
                      //TODO : generate suggestion string according to alogrithm
                      child: Text(
                        'တက်/ကျ',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    //if (_editable)
                    Opacity(
                      opacity: _editable ? 1 : 0,
                      child: IconButton(
                          onPressed: () {
                            _showDeleteConfirmDailog(record);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  ]);
                }).toList()),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDailog(BloodSugarRecord record) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('အတည်ပြုရန်'),
            content: const Text('ဖျက်ရန် သေချာပါသလား?'),
            actions: [
              TextButton(
                  onPressed: () {
                    record.delete();

                    //TODO: implement firebase record delete
                    Navigator.of(context).pop();
                  },
                  child: const Text('ဖျက်မည်')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('မဖျက်ပါ')),
            ],
          );
        });
  }
}
