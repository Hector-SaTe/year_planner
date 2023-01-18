import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueGrey, Colors.amber, Colors.pink])),
        //color: Colors.amber,
        child: const Center(child: AppTitle()),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "title",
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 3,
        child: Text(
          "Welcome to your life planner",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
