import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/data/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final _userList = FirebaseFirestore.instance.collection('users');
  final _authStateChanges = FirebaseAuth.instance.authStateChanges();

  @override
  Stream<User?> get authStateChanges => _authStateChanges;

  @override
  Future<void> addUserIfRegistered(User user) async {
    await _userList.doc(user.uid).set(<String, dynamic>{});
  }
}
