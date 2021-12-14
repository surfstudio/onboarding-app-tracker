import 'package:elementary/elementary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:time_tracker/ui/screen/auth/auth_screen_widget_model.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';

class AuthScreen extends ElementaryWidget<IAuthWidgetModel> {
  const AuthScreen({
    Key? key,
    WidgetModelFactory wmFactory = authScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IAuthWidgetModel wm) {
    return Scaffold(
      body: EntityStateNotifierBuilder<User?>(
        listenableEntityState: wm.tagListState,
        loadingBuilder: (_, __) => Container(),
        errorBuilder: (_, __, ___) => Container(),
        builder: (_, user) => user == null
            ? const SignInScreen(
                providerConfigs: [
                  GoogleProviderConfiguration(
                    clientId: '...',
                  ),
                ],
              )
            : const NoteListScreen(),
      ),
    );
  }
}