import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/data/i_auth_repository.dart';

class LocalAuthRepository implements IAuthRepository {
  @override
  // TODO(Bazarova): implement authStateChanges
  Stream<User?> get authStateChanges => throw UnimplementedError();

  @override
  Future<void> addUserIfRegistered(User user) {
    // TODO(Bazarova): implement register
    throw UnimplementedError();
  }
}
