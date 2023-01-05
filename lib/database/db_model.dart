import 'package:firebase_database/firebase_database.dart';
import 'package:year_planner/models.dart';

// Transfer class to convert from memory and save
class SaveManager {
  final String dbName = "periodList";
  late final database = FirebaseDatabase.instance.ref(dbName);

  Future<TimePeriod> createPeriod(
      String title, int teams, DateTime startRange, DateTime endRange) async {
    DatabaseReference newPeriodRef = database.push();
    await newPeriodRef.set({
      "title": title,
      "teams": teams,
      "startRange": startRange.toIso8601String(),
      "endRange": endRange.toIso8601String(),
      "teamList": []
    });
    return TimePeriod(
        id: newPeriodRef.key!,
        startRange: startRange,
        endRange: endRange,
        title: title,
        teams: teams);
  }

  Future<void> addDaysToPeriod(String id, List<Set<DateTime>> teamDays) async {
    await database.update({
      "$id/teamList": teamDays
          .map((team) => team.map((day) => day.toIso8601String()).toList())
          .toList()
    });
  }

  Future<void> removePeriod(String id) async {
    await FirebaseDatabase.instance.ref("$dbName/$id").remove();
  }

  Future<List<TimePeriod>> getPeriods() async {
    final snapshot = await database.get();
    if (snapshot.children.isNotEmpty) {
      final periods = snapshot.children.map((item) {
        final List<Set<DateTime>> teamDays = [];
        if (item.child("teamList").exists) {
          final teams = item.child("teamList").value as List;
          for (var team in teams) {
            final days = List.castFrom(team)
                .map((day) => DateTime.parse(day.toString()))
                .toSet();
            teamDays.add(days);
          }
        }
        return TimePeriod(
          id: item.key!,
          startRange: DateTime.parse(item.child("startRange").value.toString()),
          endRange: DateTime.parse(item.child("endRange").value.toString()),
          title: item.child("title").value.toString(),
          teams: item.child("teams").value as int,
          teamDays: teamDays,
        );
      }).toList();
      return periods;
    } else {
      return const [];
    }
  }
}
