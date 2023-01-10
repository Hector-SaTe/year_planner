import 'package:flutter/material.dart';
import 'package:year_planner/main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _navigateHome();
    super.initState();
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((_) => const MyHomePage())));
  }

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
        child: Center(
            child: Text(
          "Welcome to your life planner",
          style: Theme.of(context).textTheme.headlineSmall,
        )),
      ),
    );
  }
}
