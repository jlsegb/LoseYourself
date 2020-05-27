import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User {
  User({@required this.uid});

  final String uid;
}

abstract class AuthBase {
  Future<User> currentUser();

  Future<User> signInAnonymously();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebaseInstance(FirebaseUser firebaseUser) {
    if(firebaseUser == null){
      return null;
    }
    return User(uid: firebaseUser.uid);
  }

  @override
  Future<User> currentUser() async {
    final firebaseUser = await _firebaseAuth.currentUser();
    return _userFromFirebaseInstance(firebaseUser);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();

    return _userFromFirebaseInstance(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
