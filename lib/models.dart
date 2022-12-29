import 'package:flutter/foundation.dart' show immutable;
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class TimePeriod {
  final DateTime startRange;
  final DateTime endRange;
  final String title;
  final List<Set<DateTime>> teamDays;
  final int teams;

  const TimePeriod(
      {required this.startRange,
      required this.endRange,
      required this.title,
      required this.teams,
      this.teamDays = const []});
}

class TimePeriodList extends StateNotifier<List<TimePeriod>> {
  TimePeriodList([List<TimePeriod>? initialList]) : super(initialList ?? []);
  void addItem(
      String title, DateTime startRange, DateTime endRange, int teams) {
    state = [
      ...state,
      TimePeriod(
          startRange: startRange,
          endRange: endRange,
          title: title,
          teams: teams)
    ];
  }

  void addInfoAt(int index, List<Set<DateTime>> teamDays) {
    final period = state[index];
    state[index] = TimePeriod(
        startRange: period.startRange,
        endRange: period.endRange,
        title: period.title,
        teams: period.teams,
        teamDays: [...teamDays]);
  }

  void editItem(
      String title, DateTime startRange, DateTime endRange, int teams) {
    // Do not edit title, else won't be found... or use idnex
    // TODO: add old dayInfo and remove days outside new range
    state = [
      for (final period in state)
        if (period.title == title)
          TimePeriod(
              startRange: startRange,
              endRange: endRange,
              teams: teams,
              title: title)
        else
          period,
    ];
  }

  void editItemAt(int index, String title, DateTime startRange,
      DateTime endRange, int teams) {
    state[index] = TimePeriod(
        startRange: startRange, endRange: endRange, teams: teams, title: title);
  }

  void removeItem(String title) {
    state = state.where((item) => item.title != title).toList();
  }

  void removeAt(int index) => state.removeAt(index);
}
