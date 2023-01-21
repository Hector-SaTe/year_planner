import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/authentication/home_screen.dart';
import 'package:year_planner/authentication/sign_in.dart';
import 'package:year_planner/authentication/splash.dart';
import 'package:year_planner/theme/custom_theme.dart';

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
      theme: lightTheme,
      home: const AuthWrapper(),
      //initialRoute: "",
    );
  }
}

final _splashTimer = FutureProvider.autoDispose(((ref) async {
  await Future.delayed(const Duration(milliseconds: 2000));
  return true;
}));

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final splashTimer = ref.watch(_splashTimer);

    return splashTimer.when(
        loading: () => const Splash(),
        data: (data) {
          if (user == null) {
            return const SignIn();
          } else {
            return const MyHomePage();
          }
        },
        error: (err, stack) => Text('Error: $err'));
  }
}
