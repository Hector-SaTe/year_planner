import 'package:flutter/foundation.dart' show immutable;
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class TimePeriod {
  final int id;
  final DateTime startRange;
  final DateTime endRange;
  final String title;
  final List<Set<DateTime>> teamDays;
  final int teams;

  const TimePeriod(
      {required this.id,
      required this.startRange,
      required this.endRange,
      required this.title,
      required this.teams,
      this.teamDays = const []});
}

class TimePeriodList extends StateNotifier<List<TimePeriod>> {
  TimePeriodList([List<TimePeriod>? initialList]) : super(initialList ?? []);

  void addItem(TimePeriod newPeriod) {
    state = [...state, newPeriod];
  }

  void addSavedItems(List<TimePeriod> savedList) {
    state = savedList;
  }

  void addInfoAt(int id, List<Set<DateTime>> teamDays) {
    final period = state.where((item) => item.id == id).first;
    final modPeriod = TimePeriod(
        startRange: period.startRange,
        endRange: period.endRange,
        title: period.title,
        teams: period.teams,
        teamDays: [...teamDays],
        id: period.id);
    editItem(id, modPeriod);
  }

  void editItem(int id, TimePeriod modPeriod) {
    state = [
      for (final period in state)
        if (period.id == id) modPeriod else period,
    ];
  }

  /// This remove notify listeners (rebuilds)
  void removeItem(int id) {
    state = state.where((item) => item.id != id).toList();
  }
}
