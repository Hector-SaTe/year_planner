import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/models.dart';
import 'package:year_planner/providers.dart';

import '../utils.dart';

// Private Providers
final _daysInTeam =
    StateProvider.autoDispose<List<int>>(((ref) => [0, 0, 0, 0]));
final _activatedTeam = StateProvider.autoDispose<int>(((ref) => 0));
final _teamColors = Provider.autoDispose((ref) => [
      const Color.fromARGB(255, 20, 51, 191),
      const Color.fromARGB(255, 5, 137, 25),
      const Color.fromARGB(255, 134, 15, 84),
      const Color.fromARGB(255, 203, 157, 16)
    ]);

class ShowPeriod extends StatefulHookConsumerWidget {
  const ShowPeriod({super.key});

  @override
  ConsumerState<ShowPeriod> createState() => _ShowPeriodState();
}

class _ShowPeriodState extends ConsumerState<ShowPeriod> {
  //DateTime _focusedDay = DateTime.now();
  late DateTime _focusedDay;

  @override
  void initState() {
    //initialise values
    final periodIndex = ref.read(selectedItemIndex);
    final period =
        ref.read(periodListProvider.select((list) => list[periodIndex]));
    _focusedDay = period.startRange;
    if (period.teamDays.isEmpty) {
      final definedList = List.generate(
          4,
          ((index) => LinkedHashSet<DateTime>(
                equals: isSameDay,
                hashCode: getHashCode,
              )),
          growable: false);
      ref.read(periodListProvider.notifier).addInfoAt(periodIndex, definedList);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final teamColors = ref.watch(_teamColors);
    final team = ref.watch(_activatedTeam);
    final periodIndex = ref.watch(selectedItemIndex);
    final period =
        ref.watch(periodListProvider.select((list) => list[periodIndex]));
    final teamDays = period.teamDays;

    void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      setState(() {
        _focusedDay = focusedDay;
        // Update values in a Set
        if (teamDays[team].contains(selectedDay)) {
          teamDays[team].remove(selectedDay);
        } else {
          teamDays[team].add(selectedDay);
        }
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          //leading: const Image(image: AssetImage("assets/icon_2_front.png")),
          title: Text(period.title),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            TeamsWidget(period),
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: CalendarFormat.month,
              firstDay: period.startRange,
              lastDay: period.endRange,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => teamDays[team].contains(day),
              onDaySelected: onDaySelected,
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                      color: teamColors[team], shape: BoxShape.circle)),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamsWidget extends HookConsumerWidget {
  final TimePeriod period;
  const TeamsWidget(
    this.period, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Duration periodDuration =
        period.endRange.difference(period.startRange) + const Duration(days: 1);
    final teamColors = ref.watch(_teamColors);
    final daysInTeam = ref.watch(_daysInTeam);
    final team = ref.watch(_activatedTeam);
    final teamDays = period.teamDays;

    final int daysLeftSelected =
        periodDuration.inDays - teamDays.fold(0, (a, b) => a + b.length);
    final int daysLeftPlanned =
        periodDuration.inDays - daysInTeam.reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          Text(
            "Selected range: ${periodDuration.inDays} days",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 8),
          DaysLeftWidget(
            daysLeft: daysLeftPlanned,
            title: 'Planned days:',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              for (var j = 0; j < period.teams; j++)
                SizedBox(
                  width: 150,
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          activeColor: teamColors[j],
                          dense: false,
                          value: j == team,
                          onChanged: (value) {
                            ref.read(_activatedTeam.notifier).state = j;
                          },
                          title: Text("Team ${j + 1}:"),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                decoration: const InputDecoration(
                                  filled: true,
                                  isDense: true,
                                  labelText: 'Enter days',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  final List<int> selectedDays = [
                                    ...daysInTeam
                                  ];
                                  selectedDays[j] = int.tryParse(value) ?? 0;
                                  ref.read(_daysInTeam.notifier).state =
                                      selectedDays;
                                  //textController.clear();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: teamColors[j],
                              child: Text(teamDays[j].length.toString()),
                            ),
                            IconButton(
                              splashRadius: 20,
                              splashColor: teamColors[j],
                              icon: const Icon(Icons.playlist_remove),
                              onPressed: () {
                                teamDays[team].clear();
                                // A trick to force rebuild
                                final int i = j != 0 ? 0 : 1;
                                ref.read(_activatedTeam.notifier).state = i;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          DaysLeftWidget(daysLeft: daysLeftSelected, title: "Selected days:")
        ],
      ),
    );
  }
}

class DaysLeftWidget extends StatelessWidget {
  final int daysLeft;
  final String title;
  const DaysLeftWidget({Key? key, required this.daysLeft, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color iconColor = daysLeft == 0 ? Colors.green : Colors.orange;
    final String text =
        daysLeft == 0 ? "All days divided!" : "Still $daysLeft days left...";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        const SizedBox(width: 20),
        Icon(
          Icons.group_outlined,
          color: iconColor,
        ),
        const SizedBox(width: 20),
        Text(text)
      ],
    );
  }
}
