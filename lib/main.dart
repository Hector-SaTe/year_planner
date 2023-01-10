import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/screens/home_period.dart';
import 'package:year_planner/screens/splash.dart';

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
      home: const Splash(),
      //initialRoute: "",
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Text('What do you want to do?'),
          ListTile(
              title: const Text("Calendar Planner"),
              tileColor: Colors.purple,
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePeriodList()),
                  )),
          ListTile(
            title: Text("Weekly Menu"),
            tileColor: Colors.amber,
          ),
          ListTile(
            title: Text("Savings Box"),
            tileColor: Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}
