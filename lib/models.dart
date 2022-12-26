import 'package:flutter/foundation.dart' show immutable;
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TeamNames {
  team1,
  team2,
  team3,
  team4,
}

@immutable
class TimePeriod {
  final DateTime startRange;
  final DateTime endRange;
  final String title;
  final Map<String, String> dayInfo;
  final int teams;

  const TimePeriod(
      {required this.startRange,
      required this.endRange,
      required this.title,
      required this.teams,
      this.dayInfo = const {}});
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

  void addInfo(String title, Map<String, String> dayInfo) {
    state = [
      for (final period in state)
        if (period.title == title)
          TimePeriod(
              startRange: period.startRange,
              endRange: period.endRange,
              title: period.title,
              teams: period.teams,
              dayInfo: dayInfo)
        else
          period,
    ];
  }

  void editItem(String title, DateTime startRange, DateTime endRange) {
    // TODO: add old dayInfo and remove days outside new range
    state = [
      for (final period in state)
        if (period.title == title)
          TimePeriod(
              startRange: period.startRange,
              endRange: period.endRange,
              teams: period.teams,
              title: period.title)
        else
          period,
    ];
  }

  void removeItem(String title) {
    state = state.where((item) => item.title != title).toList();
  }
}
