import 'package:isar/isar.dart';
import 'package:year_planner/models.dart';

part 'db_model.g.dart';

@collection
class Period {
  Id id = Isar.autoIncrement;
  @Index()
  late DateTime startRange;
  late DateTime endRange;
  late String title;
  late List<DaySet> teamList;
  late int teams;
}

@embedded
class DaySet {
  late List<DateTime> days;
}

// Transfer class to convert from memory and save
class SaveManager {
  final Isar isar;
  SaveManager(this.isar);

  Future<void> savePeriod(Period period) async {
    // final newPeriod = Period()
    //   ..startRange = timePeriod.startRange
    //   ..endRange = timePeriod.endRange
    //   ..title = timePeriod.title
    //   ..teams = timePeriod.teams
    //   ..teamList = timePeriod.teamDays
    //       .map((set) => DaySet()..days = set.toList())
    //       .toList();
    await isar.writeTxn(() async {
      await isar.periods.put(period);
    });
  }

  Future<void> modifyPeriod(TimePeriod timePeriod) async {
    final selectedPeriod = await isar.periods.get(timePeriod.id);
    if (selectedPeriod != null) {
      selectedPeriod.teamList = timePeriod.teamDays
          .map((set) => DaySet()..days = set.toList())
          .toList();
      await isar.writeTxn(() async {
        await isar.periods.put(selectedPeriod);
      });
    }
  }

  Future<void> removePeriod(int id) async {
    await isar.writeTxn(() async {
      await isar.periods.delete(id);
    });
  }

  Future<List<TimePeriod>> getPeriods() async {
    final List<Period> list = await isar.periods.where().findAll();
    return list
        .map((period) => TimePeriod(
              id: period.id,
              startRange: period.startRange,
              endRange: period.endRange,
              title: period.title,
              teams: period.teams,
              teamDays: period.teamList
                  .map((set) => set.days.map((day) => day.toUtc()).toSet())
                  .toList(),
            ))
        .toList();
  }
}
