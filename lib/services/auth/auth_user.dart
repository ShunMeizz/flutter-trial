import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

//We shouldn't expose Firebase's user to the UI

@immutable //means this class cannot have any fields that change
class AuthUser {
  /*Previous version
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);
  //factory constructor, why? instead of manually gluing things, we can put responsibility on object y, saying
  //that you need to be able to construct an instance of yourself from this object x
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);*/

  //Current version considering auth_test: This is more robust
  //because nowhere in our application we're actually creating users except for this factory function
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
