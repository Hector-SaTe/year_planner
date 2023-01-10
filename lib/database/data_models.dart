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
      required this.teamDays});

  @override
  String toString() {
    return "$id : $title";
  }
}

class TimePeriodList extends StateNotifier<List<TimePeriod>> {
  TimePeriodList([List<TimePeriod>? initialList]) : super(initialList ?? []);

  void addItem(TimePeriod newPeriod) {
    state = [...state, newPeriod];
  }

  void addSavedItems(List<TimePeriod> savedList) {
    state = savedList;
  }

  void saveEdit(String id, String title, List<Set<DateTime>> teamDays) {
    final period = state.where((item) => item.id == id).first;
    final modPeriod = TimePeriod(
        startRange: period.startRange,
        endRange: period.endRange,
        title: title,
        pass: period.pass,
        teams: period.teams,
        teamDays: [...teamDays],
        id: period.id);
    //if (rebuild) {
    editItem(modPeriod);
    // } else {
    //   editItem(id, modPeriod);
    // }
  }

  void editItemNoRebuild(TimePeriod modPeriod) {
    // Do not rebuild:
    final pos = state.indexWhere((item) => item.id == modPeriod.id);
    state[pos] = modPeriod;
  }

  void editItem(TimePeriod modPeriod) {
    /// If needs to rebuild:
    state = [
      for (final period in state)
        if (period.id == modPeriod.id) modPeriod else period,
    ];
  }

  /// This function notifies listeners (rebuilds)
  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}
