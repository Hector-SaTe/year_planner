// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({super.key});

  @override
  State<TableBasicsExample> createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ImageIcon(
          AssetImage("assets/icon_0.png"),
          size: 24,
        ),
        title: const Text('TableCalendar - Basics'),
      ),
      body: TableCalendar(
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        headerStyle:
            const HeaderStyle(formatButtonVisible: false, titleCentered: true),
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
    );
  }
}
