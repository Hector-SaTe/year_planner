import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/models.dart';
import 'package:year_planner/providers.dart';

import '../utils.dart';

class ShowPeriod extends StatefulHookConsumerWidget {
  const ShowPeriod({super.key});

  @override
  ConsumerState<ShowPeriod> createState() => _ShowPeriodState();
}

class _ShowPeriodState extends ConsumerState<ShowPeriod> {
  //DateTime _focusedDay = DateTime.now();
  DateTime? _focusedDay;
  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      // Update values in a Set
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final periodIndex = ref.watch(selectedItemIndex);
    final period =
        ref.watch(periodListProvider.select((list) => list[periodIndex]));
    _focusedDay ??= period.startRange;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          //leading: const Image(image: AssetImage("assets/icon_2_front.png")),
          title: Text(period.title),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            TeamsWidget(period),
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: CalendarFormat.month,
              firstDay: period.startRange,
              lastDay: period.endRange,
              focusedDay: _focusedDay!,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              selectedDayPredicate: (day) => _selectedDays.contains(day),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            ),
          ],
        ),
      ),
    );
  }
}

final _daysInTeam =
    StateProvider.autoDispose<List<int>>(((ref) => [0, 0, 0, 0]));
final _activatedTeam = StateProvider.autoDispose<List<bool>>(
    ((ref) => [true, false, false, false]));
final _rangePerTeam = StateProvider(((ref) {
  final Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
}));

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
    final activatedTeam = ref.watch(_activatedTeam);
    final int daysLeft =
        periodDuration.inDays - daysInTeam.reduce((a, b) => a + b);

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
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < period.teams; i++)
                SizedBox(
                  width: 140,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        dense: true,
                        value: activatedTeam[i],
                        onChanged: (value) {
                          final List<bool> activated =
                              List.generate(4, (index) => false);
                          activated[i] = true;
                          ref.read(_activatedTeam.notifier).state = activated;
                        },
                        title: Text("Team ${i + 1}:"),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              maxLength: 3,
                              decoration: const InputDecoration(
                                labelText: 'Enter days',
                              ),
                              onChanged: (value) {
                                final List<int> selectedDays = [...daysInTeam];
                                selectedDays[i] = int.tryParse(value) ?? 0;
                                ref.read(_daysInTeam.notifier).state =
                                    selectedDays;
                                //textController.clear();
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.playlist_remove),
                            onPressed: null,
                          ),
                        ],
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
