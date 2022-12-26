import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:year_planner/pages/basics_example.dart';
import 'package:year_planner/screens/create_period.dart';
import 'package:year_planner/providers.dart';

void main() {
  initializeDateFormatting()
      .then((_) => runApp(const ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Year Planner',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodList = ref.watch(periodListProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const ImageIcon(
          AssetImage("assets/icon_0.png"),
          size: 24,
        ),
        title: const Text('Year Planner'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text('Select one time period to see:'),
          for (var i = 0; i < periodList.length; i++)
            ProviderScope(
              overrides: [
                currentItem.overrideWithValue(periodList[i]),
                currentItemIndex.overrideWithValue(i),
              ],
              child: const PeriodListItem(),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(currentItem);
    final periodindex = ref.watch(currentItemIndex);
    final Duration duration = period.endRange.difference(period.startRange);
    return ListTile(
      leading: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Image(image: AssetImage("assets/icon_2.png")),
      ),
      title: Text(period.title),
      trailing: Text("${duration.inDays} days"),
      onTap: () {
        ref.read(selectedItemIndex.notifier).state = periodindex;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TableBasicsExample(ref)),
        );
      },
    );
  }
}
