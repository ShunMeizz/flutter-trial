import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

//We shouldn't expose Firebase's user to the UI

@immutable //means this class cannot have any fields that change
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  //factory constructor, why? instead of manually gluing things, we can put responsibility on object y, saying
  //that you need to be able to construct an instance of yourself from this object x
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
