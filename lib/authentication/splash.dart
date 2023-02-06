import 'package:flutter/material.dart';
import 'package:year_planner/theme/custom_colors.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [coral_1, orange_1])),
        //color: Colors.amber,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to your organizer",
              style: Theme.of(context).primaryTextTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70),
            Text(
              "Let's plan something!",
              style: Theme.of(context).primaryTextTheme.headlineLarge,
              textAlign: TextAlign.center,
            )
          ],
        )),
      ),
    );
  }
}
