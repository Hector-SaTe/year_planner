import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/authentication/auth_service.dart';
import 'package:year_planner/database/storage_model.dart';
import 'package:year_planner/database/data_models.dart';

/// Auth provider
// 1
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// 2
final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final authServiceProvider = Provider(((ref) {
  final instance = ref.watch(firebaseAuthProvider);
  return AuthenticationService(instance);
}));

/// Database Provider
final privateDatabaseProvider = Provider((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.value?.uid != null) {
    return FirebaseDatabase.instance.ref(auth.value!.uid);
  }
  return null;
});

final publicDatabaseProvider = Provider(((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.value?.uid != null) {
    return FirebaseDatabase.instance.ref("periodList");
  }
  return null;
}));

final saveManagerProvider = Provider.family(((ref, bool public) {
  final database = ref.watch(publicDatabaseProvider);
  if (database != null) return SaveManager(database);
  return null;
}));

/// Global data provider
final periodListProvider =
    StateNotifierProvider<TimePeriodList, List<TimePeriod>>(((ref) {
  final publicDatabase = ref.watch(publicDatabaseProvider);
  final privateDatabase = ref.watch(privateDatabaseProvider);
  final publicSaveManager = ref.watch(saveManagerProvider(true));
  final privateSaveManager = ref.watch(saveManagerProvider(false));

  final timePeriodList = TimePeriodList();

  void createListeners(DatabaseReference database, SaveManager saveManager) {
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
  }

  if (publicDatabase != null && publicSaveManager != null) {
    createListeners(publicDatabase, publicSaveManager);
  }
  if (privateDatabase != null && privateSaveManager != null) {
    createListeners(privateDatabase, privateSaveManager);
  }

  return timePeriodList;
}));

final selectedPeriod =
    Provider<TimePeriod>((ref) => throw UnimplementedError());
