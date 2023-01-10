import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/database/storage_model.dart';
import 'package:year_planner/database/data_models.dart';

/// Auth provider
// // 1
// final firebaseAuthProvider =
//     Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// // 2
// final authStateChangesProvider = StreamProvider<User>(
//     (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

// // 3
// final databaseProvider = Provider<FirestoreDatabase?>((ref) {
//   final auth = ref.watch(authStateChangesProvider);

//   // we only have a valid DB if the user is signed in
//   if (auth.data?.value?.uid != null) {
//     return FirestoreDatabase(uid: auth.data!.value!.uid);
//   }
//   // else we return null
//   return null;
// });

/// Database Provider
final firebaseInstanceProvider =
    Provider(((ref) => FirebaseDatabase.instance.ref("periodList")));

final saveManagerProvider = Provider<SaveManager>(((ref) {
  final database = ref.watch(firebaseInstanceProvider);
  return SaveManager(database);
}));
// final savedPeriodProvider = FutureProvider<List<TimePeriod>>(((ref) {
//   final saveManager = ref.watch(saveManagerProvider);
//   return saveManager.getPeriods();
// }));

/// Global data provider
final periodListProvider =
    StateNotifierProvider<TimePeriodList, List<TimePeriod>>(((ref) {
  final database = ref.watch(firebaseInstanceProvider);
  final saveManager = ref.watch(saveManagerProvider);

  final timePeriodList = TimePeriodList();

  database.onChildAdded.listen((event) {
    final item = saveManager.getTimePeriod(event.snapshot);
    timePeriodList.addItem(item);
  });
  database.onChildChanged.listen((event) {
    final item = saveManager.getTimePeriod(event.snapshot);
    timePeriodList.editItem(item);
  });
  database.onChildRemoved.listen((event) {
    timePeriodList.removeItem(event.snapshot.key!);
  });

  return timePeriodList;
}));

final selectedPeriod =
    Provider<TimePeriod>((ref) => throw UnimplementedError());
