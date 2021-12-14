import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/ui/screen/auth/auth_screen.dart';
import 'package:time_tracker/ui/screen/auth/auth_screen_model.dart';

part 'i_auth_widget_model.dart';

/// Factory for [AuthScreenWidgetModel]
AuthScreenWidgetModel authScreenWidgetModelFactory(
  BuildContext context,
) {
  final model = context.read<AuthScreenModel>();
  return AuthScreenWidgetModel(model);
}

/// Widget Model for [AuthScreen]
class AuthScreenWidgetModel extends WidgetModel<AuthScreen, AuthScreenModel>
    implements IAuthWidgetModel {
  late final StreamSubscription authStateChangesSubscription;
  final _authState = EntityStateNotifier<User?>();

  @override
  ListenableState<EntityState<User?>> get tagListState => _authState;

  AuthScreenWidgetModel(AuthScreenModel model) : super(model);

  @override
  void initWidgetModel() {
    authStateChangesSubscription =
        model.authStateChanges.listen(_authStateChangesListener);
    super.initWidgetModel();
  }

  @override
  void dispose() {
    authStateChangesSubscription.cancel();
    super.dispose();
  }

  @override
  Future<void> addUserIfRegistered(User user) async {
    try {
      await model.addUserIfRegistered(user);
    } on FirebaseException catch (_) {
      throw Exception('Already exists');
    }
  }

  Future<void> _authStateChangesListener(User? user) async {
    if (user != null) {
      await addUserIfRegistered(user);
    }
    _authState.content(user);
  }
}
