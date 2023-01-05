import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/database/db_model.dart';
import 'package:year_planner/models.dart';
import 'package:year_planner/providers.dart';

import '../utils.dart';

final _titleProvider = StateProvider.autoDispose<String>(((ref) => ""));
final _teamsProvider = StateProvider.autoDispose<int>(((ref) => 2));

class SelectRange extends StatefulWidget {
  const SelectRange({super.key});

  @override
  State<SelectRange> createState() => _SelectRangeState();
}

class _SelectRangeState extends State<SelectRange> {
  final lastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Duration _rangeDuration = const Duration(days: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new entry'),
      ),
      floatingActionButton:
          SaveButton(rangeStart: _rangeStart, rangeEnd: _rangeEnd),
      body: ListView(
        children: [
          const TitleInput(),
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            firstDay: kFirstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: CalendarFormat.month,
            rangeSelectionMode: _rangeSelectionMode,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = null; // Important to clean those
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  _rangeDuration = const Duration(days: 0);
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
                if (start != null && end != null) {
                  _rangeDuration =
                      end.difference(start) + const Duration(days: 1);
                } else {
                  _rangeDuration = const Duration(days: 0);
                }
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Selected range: ${_rangeDuration.inDays} days",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleInput extends HookConsumerWidget {
  const TitleInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 0),
      child: Column(
        children: [
          Text(
            "Enter title of the Period",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          TextField(
            controller: textController,
            maxLength: 20,
            decoration: const InputDecoration(
              labelText: 'Enter title',
            ),
            onChanged: (value) {
              ref.read(_titleProvider.notifier).state = value;
              //textController.clear();
            },
          ),
          Text(
            "Number of teams: ",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          DropdownButton<int>(
              value: ref.watch(_teamsProvider),
              items: const [
                DropdownMenuItem(
                  value: 2,
                  child: Text("2 Teams"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text("3 Teams"),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Text("4 Teams"),
                )
              ],
              onChanged: ((value) =>
                  ref.read(_teamsProvider.notifier).state = value!)),
          const SizedBox(height: 8),
          Text(
            "Select the daterange for the Period",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}

class SaveButton extends ConsumerWidget {
  const SaveButton({
    Key? key,
    required DateTime? rangeStart,
    required DateTime? rangeEnd,
  })  : _rangeStart = rangeStart,
        _rangeEnd = rangeEnd,
        super(key: key);

  final DateTime? _rangeStart;
  final DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveManager = ref.watch(saveManagerProvider);

    final String title = ref.watch(_titleProvider);
    final int teams = ref.watch(_teamsProvider);
    bool deactivated =
        (title.isEmpty || _rangeStart == null || _rangeEnd == null);
    return FloatingActionButton(
      backgroundColor: deactivated ? Colors.grey : null,
      onPressed: deactivated
          ? null
          : () {
              saveManager
                  .createPeriod(title, teams, _rangeStart!, _rangeEnd!)
                  .then((newPeriod) {
                ref.read(periodListProvider.notifier).addItem(newPeriod);
              });
              Navigator.pop(context);
            },
      tooltip: 'save Item',
      child: const Icon(Icons.save),
    );
  }
}
