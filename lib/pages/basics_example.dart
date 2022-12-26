import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/models.dart';
import 'package:year_planner/providers.dart';

import '../utils.dart';

class TableBasicsExample extends StatefulHookConsumerWidget {
  const TableBasicsExample({super.key});

  @override
  ConsumerState<TableBasicsExample> createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends ConsumerState<TableBasicsExample> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final periodIndex = ref.watch(selectedItemIndex);
    final period =
        ref.watch(periodListProvider.select((list) => list[periodIndex]));
    return Scaffold(
      appBar: AppBar(
        //leading: const Image(image: AssetImage("assets/icon_2_front.png")),
        title: Text(period.title),
      ),
      body: ListView(
        children: [
          TeamsWidget(period),
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}

final _daysInTeam =
    StateProvider.autoDispose<List<int>>(((ref) => [0, 0, 0, 0]));

class TeamsWidget extends HookConsumerWidget {
  final TimePeriod period;
  const TeamsWidget(
    this.period, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodIndex = ref.watch(selectedItemIndex);
    final Duration periodDuration =
        period.endRange.difference(period.startRange);
    final daysInTeam = ref.watch(_daysInTeam);
    final int daysLeft =
        periodDuration.inDays - daysInTeam.reduce((a, b) => a + b);
    List<int> selectedDays = [0, 0, 0, 0];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Selected range: ${periodDuration.inDays} days",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          (daysLeft == 0)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.group_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: 20),
                    Text("All days divided!")
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.group_off_outlined,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 20),
                    Text("Still $daysLeft days left..."),
                  ],
                ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              for (var i = 0; i < period.teams; i++)
                SizedBox(
                  width: 124,
                  child: Column(
                    children: [
                      Text("Team ${i + 1}:"),
                      TextField(
                        maxLength: 3,
                        decoration: const InputDecoration(
                          labelText: 'Enter days',
                        ),
                        onChanged: (value) {
                          selectedDays = [...daysInTeam];
                          selectedDays[i] = int.tryParse(value) ?? 0;
                          ref.read(_daysInTeam.notifier).state = selectedDays;
                          //textController.clear();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
