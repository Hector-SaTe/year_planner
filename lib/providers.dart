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
final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final authServiceProvider = Provider(((ref) {
  final instance = ref.watch(firebaseAuthProvider);
  return AuthenticationService(instance);
}));

/// Database Provider
final databaseProvider = Provider((ref) {
  final auth = ref.watch(authStateProvider);

  if (auth.value?.uid != null) {
    return FirebaseDatabase.instance;
  }
  return null;
});

final saveManagerProvider = Provider.family(((ref, bool public) {
  final database = ref.watch(databaseProvider);
  final auth = ref.watch(authStateProvider);

  if (database != null) {
    if (public) {
      final databaseRef = database.ref("periodList");
      return SaveManager(databaseRef);
    } else {
      final databaseRef = database.ref("${auth.value?.uid}/periodList");
      return SaveManager(databaseRef);
    }
  } else {
    return null;
  }
}));

/// Global data provider
final periodListProvider =
    StateNotifierProvider<TimePeriodList, List<TimePeriod>>(((ref) {
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

  if (publicSaveManager != null) {
    createListeners(publicSaveManager.database, publicSaveManager);
  }
  if (privateSaveManager != null) {
    createListeners(privateSaveManager.database, privateSaveManager);
  }

  return timePeriodList;
}));

final selectedPeriod =
    Provider<TimePeriod>((ref) => throw UnimplementedError());
