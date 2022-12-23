import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class TimePeriod {
  final DateTime startRange;
  final DateTime endRange;
  final String title;
  final Map<String, String> dayInfo;

  const TimePeriod(
      {required this.startRange,
      required this.endRange,
      required this.title,
      this.dayInfo = const {}});
}

class TimePeriodList extends StateNotifier<List<TimePeriod>> {
  TimePeriodList([List<TimePeriod>? initialList]) : super(initialList ?? []);
  void addItem(String title, DateTime startRange, DateTime endRange) {
    state = [
      ...state,
      TimePeriod(startRange: startRange, endRange: endRange, title: title)
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
              title: period.title)
        else
          period,
    ];
  }

  void removeItem(String title) {
    state = state.where((item) => item.title != title).toList();
  }
}
