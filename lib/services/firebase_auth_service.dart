import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show debugPrint;

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUserWithEmailAndPassword(
    String userEmail,
    String userPassword,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
    } on FirebaseAuthException catch (exception) {
      debugPrint(exception.message);
    }
  }

  Future<void> signInUserWithEmailAndPassword(
    String userEmail,
    String userPassword,
  ) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: userEmail.trim(),
        password: userPassword,
      );
    } on FirebaseAuthException catch (exception) {
      debugPrint(exception.message);
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addUserName(String newUserName) async {
    await _firebaseAuth.currentUser!.updateDisplayName(newUserName);
  }

  String username() {
    return _firebaseAuth.currentUser!.displayName!;
  }
}
