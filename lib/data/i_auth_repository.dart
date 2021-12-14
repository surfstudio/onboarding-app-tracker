import 'dart:async';

abstract class IAuthRepository {
  Future<void> register();

  Future<void> login();

  Future<void> logout();
}
