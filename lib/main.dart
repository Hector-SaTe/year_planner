import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/screens/show_period.dart';
import 'package:year_planner/screens/create_period.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/utils/pop_up.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    final saveManager = ref.watch(saveManagerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(2.0),
          child: ImageIcon(
            AssetImage("assets/icon_0.png"),
            size: 24,
          ),
        ),
        title: const Text('Year Planner'),
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
                saveManager.removePeriod(item.id).then((manager) {
                  // delete element from memory list
                  ref.read(periodListProvider.notifier).removeItem(item.id);
                });
              },
              child: ProviderScope(
                overrides: [
                  currentItemId.overrideWithValue(item.id),
                ],
                child: const PeriodListItem(),
              ),
            )
        ],
      ),
      persistentFooterButtons: [
        const Text("Load List"),
        IconButton(
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: () async {
            saveManager.getPeriods().then((dbPeriods) =>
                ref.read(periodListProvider.notifier).addSavedItems(dbPeriods));
            // ref.invalidate(savedPeriodProvider);
            // ref.read(savedPeriodProvider.future).then((savedList) {
            //   ref.read(periodListProvider.notifier).addSavedItems(savedList);
            // });
          },
        ),
        // const Text("Test"),
        // IconButton(
        //   icon: const Icon(Icons.textsms),
        //   onPressed: (() => getPassword(context, "pass")),
        // )
      ],
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
    final periodId = ref.watch(currentItemId);
    final period = ref.watch(periodListProvider
        .select((list) => list.where((item) => item.id == periodId).first));
    final Duration duration =
        period.endRange.difference(period.startRange) + const Duration(days: 1);

    return ListTile(
      leading: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Image(image: AssetImage("assets/icon_2_front.png")),
      ),
      title: Text(period.title),
      subtitle: Text(
          "${dateToString(period.startRange)} to ${dateToString(period.endRange)}"),
      trailing: Text("${duration.inDays} days"),
      onTap: () {
        ref.read(selectedItemId.notifier).state = periodId;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ShowPeriod()),
        );
      },
    );
  }
}
