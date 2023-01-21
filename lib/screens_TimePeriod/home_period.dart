import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/screens_TimePeriod/show_period.dart';
import 'package:year_planner/screens_TimePeriod/create_period.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/utils/pop_up.dart';

class HomePeriodList extends ConsumerWidget {
  const HomePeriodList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodList = ref.watch(periodListProvider);
    final publicSaveManager = ref.watch(saveManagerProvider(true));
    final privateSaveManager = ref.watch(saveManagerProvider(false));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Planner'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text('Select one time period to see:'),
          for (final item in periodList)
            Dismissible(
              key: ValueKey(item.id),
              confirmDismiss: (direction) => getPassword(context, item.pass),
              onDismissed: (direction) {
                item.public
                    ? publicSaveManager!.removePeriod(item.id)
                    : privateSaveManager!.removePeriod(item.id);
              },
              child: ProviderScope(
                overrides: [
                  selectedPeriod.overrideWithValue(item),
                ],
                child: const PeriodListItem(),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SelectRange()),
        ),
        tooltip: 'new Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PeriodListItem extends ConsumerWidget {
  const PeriodListItem({Key? key}) : super(key: key);
  String dateToString(DateTime date) =>
      DateFormat('dd.MM.yy', 'es').format(date);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(selectedPeriod);
    final Duration duration =
        period.endRange.difference(period.startRange) + const Duration(days: 1);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      leading: const Image(image: AssetImage("assets/icon_2_front.png")),
      title: Text(period.title),
      subtitle: Text(
          "${dateToString(period.startRange)} to ${dateToString(period.endRange)}"),
      trailing: Text("${duration.inDays} days"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProviderScope(overrides: [
                    selectedPeriod.overrideWithValue(period),
                  ], child: const ShowPeriod())),
        );
      },
    );
  }
}
