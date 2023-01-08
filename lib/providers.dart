import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/database/storage_model.dart';
import 'package:year_planner/database/data_models.dart';

/// Database Provider
final saveManagerProvider = Provider<SaveManager>(((ref) {
  return SaveManager();
}));
// final savedPeriodProvider = FutureProvider<List<TimePeriod>>(((ref) {
//   final saveManager = ref.watch(saveManagerProvider);
//   return saveManager.getPeriods();
// }));

/// Global data provider
final periodListProvider =
    StateNotifierProvider<TimePeriodList, List<TimePeriod>>(((ref) {
  // final savedList = await ref.watch(savedPeriodProvider.future);
  // if(savedList.isNotEmpty) {
  return TimePeriodList([
    // TimePeriod(
    //     id: 0,
    //     startRange: DateTime(2022, 12, 1, 0, 0),
    //     endRange: DateTime(2023, 1, 10, 0, 0),
    //     teams: 2,
    //     title: "example period")
  ]);
  // } else {
  //   return TimePeriodList(savedList);
  // }
}));

final currentItemId = Provider<String>((ref) => throw UnimplementedError());
final selectedItemId = StateProvider<String>((_) => "");
