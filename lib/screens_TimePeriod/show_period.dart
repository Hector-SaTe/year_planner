import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:year_planner/database/data_models.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/utils/pop_up.dart';

// Private Providers
final _editTeams = StateProvider.autoDispose<bool>(((ref) => false));
final _activatedTeam = StateProvider.autoDispose<int>(((ref) => 0));
final _editTitle = StateProvider.autoDispose<String>(((ref) => ""));
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
  late DateTime _focusedDay;

  int? whichTeamIsThis(List<Set<DateTime>> teamList, DateTime day) {
    //list.fold(false,(previousValue, element) => previousValue || element.contains(day));
    int? getTeam;
    for (var i = 0; i < teamList.length; i++) {
      if (teamList[i].contains(day)) getTeam = i;
    }
    return getTeam; // Returns null if not found
  }

  @override
  void initState() {
    //initialise values
    _focusedDay = ref.read(selectedPeriod.select((value) => value.startRange));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editTitle = ref.watch(_editTitle);
    final editMode = ref.watch(_editTeams);
    final teamColors = ref.watch(_teamColors);
    final team = ref.watch(_activatedTeam);

    final period = ref.watch(selectedPeriod);
    final teamDays = period.teamDays;
    final totalDays = teamDays.fold(<DateTime>{},
        (previousValue, element) => {...previousValue, ...element});

    CalendarStyle getCalendarStyle(int team) {
      return CalendarStyle(
          selectedDecoration:
              BoxDecoration(color: teamColors[team], shape: BoxShape.circle));
    }

    void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      if (editMode) {
        setState(() {
          final int? foundTeam = whichTeamIsThis(teamDays, selectedDay);
          _focusedDay = focusedDay;
          // Day inside some team
          if (foundTeam == null) {
            teamDays[team].add(selectedDay);
          } else if (foundTeam == team) {
            teamDays[team].remove(selectedDay);
          } else {
            teamDays[foundTeam].remove(selectedDay);
            teamDays[team].add(selectedDay);
          }
        });
      }
    }

    Widget? daySelectedBuilder(
        BuildContext context, DateTime selectedDay, DateTime focusedDay) {
      final int? foundTeam = whichTeamIsThis(teamDays, selectedDay);
      if (foundTeam != null) {
        final calendarStyle = getCalendarStyle(foundTeam);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: calendarStyle.cellMargin,
          padding: calendarStyle.cellPadding,
          decoration: calendarStyle.selectedDecoration,
          alignment: calendarStyle.cellAlignment,
          child: Text('${selectedDay.day}',
              style: calendarStyle.selectedTextStyle),
        );
      } else {
        return null;
      }
    }

    final titleController = useTextEditingController(text: period.title);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [EditButtons(period)],
          title: editMode
              ? TextField(
                  controller: titleController,
                  maxLength: 20,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.edit),
                      labelText: 'change title',
                      border: InputBorder.none),
                  onChanged: (value) {
                    ref.read(_editTitle.notifier).state = value;
                  },
                )
              : Text(editTitle.isEmpty ? period.title : editTitle),
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
              calendarBuilders:
                  CalendarBuilders(selectedBuilder: daySelectedBuilder),
              selectedDayPredicate: (day) => totalDays.contains(day),
              onDaySelected: onDaySelected,
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
            ),
          ],
        ),
      ),
    );
  }
}

class EditButtons extends ConsumerWidget {
  final TimePeriod period;
  const EditButtons(
    this.period, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveManager = ref.watch(saveManagerProvider(period.public));
    final editMode = ref.watch(_editTeams);
    final editTitle = ref.watch(_editTitle);
    const double iconSize = 30;

    void edit() async {
      final confirmation = await getPassword(context, period.pass);
      if (confirmation == true) {
        ref.read(_editTeams.notifier).state = true;
      }
    }

    void discard() async {
      ref.read(_editTeams.notifier).state = false;
      final oldPeriod = await saveManager!.getPeriod(period.id);
      ref.read(periodListProvider.notifier).editItem(oldPeriod);
    }

    void save() {
      ref.read(_editTeams.notifier).state = false;
      ref
          .read(periodListProvider.notifier)
          .saveEdit(period.id, editTitle, period.teamDays);
      saveManager!.editPeriod(period.id, editTitle, period.teamDays);
      const message = SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Nice! changes were saved'),
      );
      ScaffoldMessenger.of(context).showSnackBar(message);
    }

    return Row(
      children: [
        if (editMode)
          IconButton(
              iconSize: iconSize,
              onPressed: save,
              icon: const Icon(Icons.save)),
        IconButton(
            iconSize: iconSize,
            onPressed: editMode ? discard : edit,
            icon: editMode
                ? const Icon(Icons.delete_forever)
                : const Icon(Icons.edit_calendar)),
      ],
    );
  }
}

class TeamsWidget extends ConsumerWidget {
  final TimePeriod period;
  const TeamsWidget(
    this.period, {
    Key? key,
  }) : super(key: key);
  String dateToString(DateTime date) =>
      DateFormat('EEE, dd MMM yyyy', 'en').format(date);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(color: Theme.of(context).primaryColor);
    final Duration periodDuration =
        period.endRange.difference(period.startRange) + const Duration(days: 1);
    final teamColors = ref.watch(_teamColors);
    final team = ref.watch(_activatedTeam);
    final editMode = ref.watch(_editTeams);
    final teamDays = period.teamDays;

    final int daysLeftSelected =
        periodDuration.inDays - teamDays.fold(0, (a, b) => a + b.length);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dateToString(period.startRange), style: titleStyle),
                  Text(dateToString(period.endRange), style: titleStyle),
                ],
              ),
              SizedBox(
                height: 40,
                width: 30,
                child: VerticalDivider(
                  thickness: 2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text("${periodDuration.inDays} days", style: titleStyle),
            ],
          ),
          const SizedBox(height: 8),
          DaysLeftTitle(daysLeft: daysLeftSelected, title: "Selected days:"),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              for (var j = 0; j < period.teams; j++)
                SizedBox(
                  width: 160,
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: editMode
                        ? SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 4, 12, 4),
                            activeColor: teamColors[j],
                            dense: false,
                            value: j == team,
                            onChanged: (value) {
                              ref.read(_activatedTeam.notifier).state = j;
                            },
                            title: Text("Team ${j + 1}:"),
                            subtitle: DaysSelectedCounter(
                                teamColor: teamColors[j], daysSet: teamDays[j]),
                          )
                        : ListTile(
                            title: Text("Team ${j + 1}:"),
                            trailing: DaysSelectedCounter(
                                teamColor: teamColors[j], daysSet: teamDays[j]),
                          ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class DaysSelectedCounter extends StatelessWidget {
  const DaysSelectedCounter({
    Key? key,
    required this.teamColor,
    required this.daysSet,
  }) : super(key: key);

  final Color teamColor;
  final Set<DateTime> daysSet;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(shape: BoxShape.circle, color: teamColor),
        child: Text(
          daysSet.length.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ));
  }
}

class ClearListButton extends ConsumerWidget {
  const ClearListButton({
    Key? key,
    required this.period,
  }) : super(key: key);

  final TimePeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: "Clear all lists",
      color: Theme.of(context).primaryColor,
      iconSize: 20,
      splashRadius: 25,
      icon: const Icon(Icons.playlist_remove),
      onPressed: () {
        for (var teamSet in period.teamDays) {
          teamSet.clear();
        }
        ref.read(periodListProvider.notifier).editItem(period);
      },
    );
  }
}

class DaysLeftTitle extends StatelessWidget {
  final int daysLeft;
  final String title;
  const DaysLeftTitle({Key? key, required this.daysLeft, required this.title})
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
