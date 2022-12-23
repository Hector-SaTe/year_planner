import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

const String exampleName = "example period";

final periodListProvider =
    StateNotifierProvider<TimePeriodList, List<TimePeriod>>(
        ((ref) => TimePeriodList([
              TimePeriod(
                  startRange: DateTime(2022, 12, 1, 0, 0),
                  endRange: DateTime(2023, 1, 10, 0, 0),
                  title: exampleName)
            ])));

final periodSelectionProvider = StateProvider(((_) => exampleName));
final currentItem = Provider<TimePeriod>((ref) => throw UnimplementedError());

final selectedPeriodProvider = Provider<TimePeriod>(((ref) {
  final selection = ref.watch(periodSelectionProvider);
  final periodList = ref.watch(periodListProvider);

  return periodList.firstWhere((item) => item.title == selection);
}));
