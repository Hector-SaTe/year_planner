import 'package:flutter/foundation.dart' show immutable;
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class TimePeriod {
  final String id;
  final DateTime startRange;
  final DateTime endRange;
  final String title;
  final String pass;
  final List<Set<DateTime>> teamDays;
  final int teams;

  const TimePeriod(
      {required this.id,
      required this.pass,
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

  void saveEdit(
      String id, String title, List<Set<DateTime>> teamDays, bool rebuild) {
    final period = state.where((item) => item.id == id).first;
    final modPeriod = TimePeriod(
        startRange: period.startRange,
        endRange: period.endRange,
        title: title,
        pass: period.pass,
        teams: period.teams,
        teamDays: [...teamDays],
        id: period.id);
    if (rebuild) {
      editItemRebuild(id, modPeriod);
    } else {
      editItem(id, modPeriod);
    }
  }

  void editItem(String id, TimePeriod modPeriod) {
    // Do not rebuild:
    final pos = state.indexWhere((item) => item.id == id);
    state[pos] = modPeriod;
  }

  void editItemRebuild(String id, TimePeriod modPeriod) {
    /// If needs to rebuild:
    state = [
      for (final period in state)
        if (period.id == id) modPeriod else period,
    ];
  }

  /// This function notifies listeners (rebuilds)
  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}
