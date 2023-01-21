import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/screens_TimePeriod/home_period.dart';
import 'package:year_planner/theme/custom_colors.dart';
import 'package:year_planner/utils/snackbar_messages.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyBG,
        title: Text(
          'What do you want to do?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        children: [
          MainMenuItem(
            title: "Vacation planner",
            backColor: lila01,
            image: Image.asset("assets/menu_vacation.png"),
            width: 140,
            pageToGo: const HomePeriodList(),
          ),
          MainMenuItem(
            title: "Menu planner",
            backColor: coral01,
            image: Image.asset("assets/menu_food.png"),
            width: 120,
          ),
          MainMenuItem(
            title: "Savings planner",
            backColor: orange01,
            image: Image.asset("assets/menu_savings.png"),
            width: 110,
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: base),
          onPressed: (() => ref.read(authServiceProvider).signOut().then((_) =>
              showSnackBarMessage(context, "Signed out", SnackBarType.info))),
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
    const double cardHeight = 130.0;
    return Card(
      color: backColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: GestureDetector(
        onTap: enabled
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => pageToGo!),
                )
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: cardHeight,
              child: Row(
                children: [
                  const SizedBox(width: 160),
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).primaryTextTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(left: 0, bottom: 0, width: width, child: image)
          ],
        ),
      ),
    );
  }
}
