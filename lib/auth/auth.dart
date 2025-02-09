import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firbaseAuth = FirebaseAuth.instance;

  User? get user => _firbaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firbaseAuth.authStateChanges();

  Future<void> signInWithEmialAndPassword({required String email,required String password}) async {
    await _firbaseAuth.signInWithEmailAndPassword(email: email, password: password);
  } 

  Future<void> signOut() async {
    await _firbaseAuth.signOut();
  }
}
 