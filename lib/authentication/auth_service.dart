import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return " Signed out! ";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> resetPass({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return " Password reset Email sent ";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return " Signed in ";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return " Signed up ";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
