import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/screens_TimePeriod/home_period.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          MainMenuItem(
            title: "Calendar Planner",
            backColor: Colors.purple.shade200,
            image: Image.asset("assets/icon_2_alone.png"),
            width: 60,
            pageToGo: const HomePeriodList(),
          ),
          MainMenuItem(
            title: "Weekly Menu",
            backColor: Colors.amber.shade200,
            image: Image.asset("assets/icon_2_alone.png"),
            width: 60,
          ),
          MainMenuItem(
            title: "Savings Box",
            backColor: Colors.green.shade200,
            image: Image.asset("assets/icon_2_alone.png"),
            width: 60,
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
          onPressed: (() => ref.read(authServiceProvider).signOut()),
          child: const Text("Sign out")),
    );
  }
}

class MainMenuItem extends StatelessWidget {
  final Color backColor;
  final String title;
  final Image image;
  final double width;
  final Widget? pageToGo;
  const MainMenuItem({
    Key? key,
    required this.backColor,
    required this.title,
    required this.image,
    required this.width,
    this.pageToGo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enabled = pageToGo != null;
    return Card(
      color: backColor,
      margin: const EdgeInsets.all(24),
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ListTile(
              leading: SizedBox(width: width),
              title: Text(title),
              enabled: enabled,
              onTap: enabled
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => pageToGo!),
                      )
                  : null),
          Positioned(left: 0, top: -15, width: width, child: image)
        ],
      ),
    );
  }
}
