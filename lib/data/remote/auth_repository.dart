import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/data/i_auth_repository.dart';
import 'package:time_tracker/ui/common/alias/json_data_alias.dart';

class AuthRepository implements IAuthRepository {
  final firestoreInstance = FirebaseFirestore.instance;
  final authInstance = FirebaseAuth.instance;
  late final CollectionReference<JsonData> _userList;
  late final Stream<User?> _authStateChanges;

  @override
  Stream<User?> get authStateChanges => _authStateChanges;

  AuthRepository() {
    _userList = firestoreInstance.collection('users');
    _authStateChanges = authInstance.authStateChanges();
  }

  @override
  Future<void> addUserIfRegistered(User user) async {
    await _userList.doc(user.uid).set(<String, dynamic>{});
  }
}
