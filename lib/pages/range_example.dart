import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/providers.dart';

import '../utils.dart';

class TableRangeExample extends StatefulWidget {
  const TableRangeExample({super.key});

  @override
  State<TableRangeExample> createState() => _TableRangeExampleState();
}

class _TableRangeExampleState extends State<TableRangeExample> {
  final lastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? _title;

  @override
  Widget build(BuildContext context) {
    _title = "katapum";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new entry'),
      ),
      floatingActionButton: SaveButton(
          title: _title, rangeStart: _rangeStart, rangeEnd: _rangeEnd),
      body: Column(
        children: [
          const Text("Name of the period:"),
          Text(_title ?? "-"),
          const SizedBox(height: 20),
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = null; // Important to clean those
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}

class SaveButton extends ConsumerWidget {
  const SaveButton({
    Key? key,
    required String? title,
    required DateTime? rangeStart,
    required DateTime? rangeEnd,
  })  : _title = title,
        _rangeStart = rangeStart,
        _rangeEnd = rangeEnd,
        super(key: key);

  final String? _title;
  final DateTime? _rangeStart;
  final DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: (_title == null || _rangeStart == null || _rangeEnd == null)
          ? null
          : () {
              ref
                  .read(periodListProvider.notifier)
                  .addItem(_title!, _rangeStart!, _rangeEnd!);
              Navigator.pop(context);
            },
      tooltip: 'save Item',
      child: const Icon(Icons.save),
    );
  }
}
