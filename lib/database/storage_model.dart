import 'package:firebase_database/firebase_database.dart';
import 'package:year_planner/database/data_models.dart';

// Transfer class to convert from memory and save
class SaveManager {
  final DatabaseReference database;
  SaveManager(this.database);

  //final database = FirebaseDatabase.instance.ref("periodList");

  Future<TimePeriod> createPeriod(String title, int teams, DateTime startRange,
      DateTime endRange, String pass, List<Set<DateTime>> teamList) async {
    DatabaseReference newPeriodRef = database.push();
    await newPeriodRef.set({
      "title": title,
      "teams": teams,
      "pass": pass,
      "startRange": startRange.toIso8601String(),
      "endRange": endRange.toIso8601String(),
      "teamList": convertTeamList(teamList)
    });
    return TimePeriod(
        id: newPeriodRef.key!,
        startRange: startRange,
        endRange: endRange,
        title: title,
        pass: pass,
        teams: teams,
        teamDays: teamList);
  }

  Future<void> editPeriod(
      String id, String title, List<Set<DateTime>> teamList) async {
    await database.update(
        {"$id/title": title, "$id/teamList": convertTeamList(teamList)});
  }

  List<List<String>> convertTeamList(List<Set<DateTime>> teamList) => teamList
      .map((team) => team.map((day) => day.toIso8601String()).toList())
      .toList();

  Future<void> removePeriod(String id) async {
    await database.child(id).remove();
  }

  Future<TimePeriod> getPeriod(String id) async {
    final item = await database.child(id).get();
    return getTimePeriod(item);
  }

  TimePeriod getTimePeriod(DataSnapshot item) {
    final List<Set<DateTime>> teamList = [];

    if (item.child("teamList").exists) {
      teamList.addAll((item.child("teamList").value as List).map((team) =>
          List.castFrom(team)
              .map((day) => DateTime.parse(day.toString()))
              .toSet()));
    }
    return TimePeriod(
      id: item.key!,
      pass: item.child("pass").value.toString(),
      startRange: DateTime.parse(item.child("startRange").value.toString()),
      endRange: DateTime.parse(item.child("endRange").value.toString()),
      title: item.child("title").value.toString(),
      teams: item.child("teams").value as int,
      teamDays: teamList,
    );
  }
}
