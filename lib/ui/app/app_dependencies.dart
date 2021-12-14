import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/data/i_auth_repository.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/data/remote/auth_repository.dart';
import 'package:time_tracker/data/remote/note_repository.dart';
import 'package:time_tracker/data/remote/tag_repository.dart';
import 'package:time_tracker/ui/app/app.dart';
import 'package:time_tracker/ui/common/error_handlers/default_error_handler.dart';
import 'package:time_tracker/ui/screen/auth/auth_screen_model.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_model.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen_model.dart';

/// Widget with dependencies that live all runtime.
class AppDependencies extends StatefulWidget {
  final App app;

  const AppDependencies({required this.app, Key? key}) : super(key: key);

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  late final DefaultErrorHandler _defaultErrorHandler;
  late final IAuthRepository _authRepository;
  late final INoteRepository _noteRepository;
  late final ITagRepository _tagRepository;
  late final AuthScreenModel _authScreenModel;
  late final NoteListScreenModel _noteListScreenModel;
  late final TagListScreenModel _tagListScreenModel;

  late final ThemeWrapper _themeWrapper;

  @override
  void initState() {
    super.initState();

    _defaultErrorHandler = DefaultErrorHandler();
    _authRepository = AuthRepository();
    _noteRepository = NoteRepository();
    _tagRepository = TagRepository();

    _authScreenModel = AuthScreenModel(
      _authRepository,
      _defaultErrorHandler,
    );

    _tagListScreenModel = TagListScreenModel(
      _tagRepository,
      _defaultErrorHandler,
    );

    _noteListScreenModel = NoteListScreenModel(
      _noteRepository,
      _tagListScreenModel,
      _defaultErrorHandler,
    );

    _themeWrapper = ThemeWrapper();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthScreenModel>(
          create: (_) => _authScreenModel,
        ),
        Provider<NoteListScreenModel>(
          create: (_) => _noteListScreenModel,
        ),
        Provider<TagListScreenModel>(
          create: (_) => _tagListScreenModel,
        ),
        Provider<ThemeWrapper>(
          create: (_) => _themeWrapper,
        ),
      ],
      child: widget.app,
    );
  }
}
