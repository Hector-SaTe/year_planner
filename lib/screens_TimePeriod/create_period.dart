import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/utils/calendar_utils.dart';

final _publicProvider = StateProvider.autoDispose<bool>(((ref) => false));
final _titleProvider = StateProvider.autoDispose<String>(((ref) => ""));
final _passProvider = StateProvider.autoDispose<String>(((ref) => ""));
final _teamsProvider = StateProvider.autoDispose<int>(((ref) => 2));
final _emptyTeamListProvider = Provider.autoDispose(((ref) => List.generate(
    4,
    ((index) => LinkedHashSet<DateTime>(
          equals: isSameDay,
          hashCode: getHashCode,
        )),
    growable: false)));

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            const SizedBox(height: 50)
          ],
        ),
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
    const double titleWidth = 100;
    final public = ref.watch(_publicProvider);
    final titleController = useTextEditingController();
    final passController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: titleWidth,
                child: Text(
                  "Title",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Flexible(
                child: TextField(
                  controller: titleController,
                  maxLength: 20,
                  decoration: const InputDecoration(labelText: 'Enter title'),
                  onChanged: (value) {
                    ref.read(_titleProvider.notifier).state = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Should be public?",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Checkbox(
                    value: public,
                    onChanged: (value) {
                      ref.read(_publicProvider.notifier).state = value!;
                    }),
              ),
              Text(public ? "Yes" : "No")
            ],
          ),
          if (public)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: titleWidth,
                  height: 70,
                  child: Text(
                    "Password: ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: passController,
                    maxLength: 10,
                    decoration: const InputDecoration(
                        labelText: 'Enter password',
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        )),
                    onChanged: (value) {
                      ref.read(_passProvider.notifier).state = value;
                      //textController.clear();
                    },
                  ),
                ),
              ],
            ),
          Row(
            children: [
              SizedBox(
                width: titleWidth,
                child: Text(
                  "Teams: ",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
              Flexible(
                child: DropdownButtonFormField<int>(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    decoration: const InputDecoration(
                        labelText: 'Select number of teams',
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        )),
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
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Select date range:",
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
    required this.rangeStart,
    required this.rangeEnd,
  }) : super(key: key);

  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final public = ref.watch(_publicProvider);
    final title = ref.watch(_titleProvider);
    final pass = ref.watch(_passProvider);
    final teams = ref.watch(_teamsProvider);
    final teamList = ref.watch(_emptyTeamListProvider);

    bool deactivated =
        (title.isEmpty || rangeStart == null || rangeEnd == null);

    void divideDaysInRange() {
      final totalDays = daysInRange(rangeStart!, rangeEnd!);
      final double daysPerTeam = totalDays.length / teams;
      for (var i = 0; i < totalDays.length; i++) {
        for (var j = 1; j <= teams; j++) {
          if (i < j * daysPerTeam && i >= (j - 1) * daysPerTeam) {
            teamList[j - 1].add(totalDays[i]);
          }
        }
      }
    }

    void savePeriod() {
      ref
          .read(saveManagerProvider(public))!
          .createPeriod(
              title, teams, rangeStart!, rangeEnd!, pass, teamList, public)
          .then((newPeriod) {
        Navigator.pop(context);
      });
    }

    return FloatingActionButton(
      backgroundColor: deactivated ? Colors.grey : null,
      onPressed: deactivated
          ? null
          : () {
              divideDaysInRange();
              savePeriod();
            },
      tooltip: 'save Item',
      child: const Icon(
        Icons.save,
        size: 35,
      ),
    );
  }
}
