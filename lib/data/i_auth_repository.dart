import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  /// Real-time changes in auth state stream
  Stream<User?> get authStateChanges;

  Future<void> addUserIfRegistered(User user);
}
