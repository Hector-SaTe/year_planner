import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'models.dart';

const String exampleName = "example period";

final periodListProvider =
    StateNotifierProvider<TimePeriodList, List<TimePeriod>>(
        ((ref) => TimePeriodList([
              TimePeriod(
                  startRange: DateTime(2022, 12, 1, 0, 0),
                  endRange: DateTime(2023, 1, 10, 0, 0),
                  teams: 2,
                  title: exampleName)
            ])));

final currentItemIndex = Provider<int>((ref) => throw UnimplementedError());
final selectedItemIndex = StateProvider<int>((_) => 0);
