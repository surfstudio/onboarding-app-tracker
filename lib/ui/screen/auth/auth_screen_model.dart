import 'package:elementary/elementary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/data/i_auth_repository.dart';

class AuthScreenModel extends ElementaryModel implements IAuthRepository {
  final IAuthRepository _authRepository;

  @override
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  AuthScreenModel(
    this._authRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  Future<void> addUserIfRegistered(User user) async {
    await _authRepository.addUserIfRegistered(user);
  }
}
