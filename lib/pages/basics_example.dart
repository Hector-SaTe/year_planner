import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/models.dart';
import 'package:year_planner/providers.dart';

import '../utils.dart';

class TableBasicsExample extends StatefulHookConsumerWidget {
  final WidgetRef ref;
  const TableBasicsExample(this.ref, {super.key});

  @override
  ConsumerState<TableBasicsExample> createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends ConsumerState<TableBasicsExample> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final period = widget.ref.watch(currentItem);
    return Scaffold(
      appBar: AppBar(
        //leading: const Image(image: AssetImage("assets/icon_2_front.png")),
        title: Text(period.title),
      ),
      body: ListView(
        children: [
          TeamsWidget(widget.ref),
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

class TeamsWidget extends HookConsumerWidget {
  final WidgetRef ref;
  const TeamsWidget(
    this.ref, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef refnew) {
    final period = ref.watch(currentItem);
    final Duration periodDuration =
        period.endRange.difference(period.startRange);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          //const Text("Enter number of days to share"),
          Text("Still ${periodDuration.inDays} days to share"),
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
                      Text("Enter days for team ${i + 1}:"),
                      TextField(
                        maxLength: 3,
                        decoration: const InputDecoration(
                          labelText: 'Enter days',
                        ),
                        onChanged: (value) {
                          print(value);
                          //ref.read(_titleProvider.notifier).state = value;
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
