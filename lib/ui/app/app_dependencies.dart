import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/data/cloud_firestore_repository.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/ui/app/app.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_model.dart';
import 'package:time_tracker/utils/error/default_error_handler.dart';

/// Widget with dependencies that live all runtime.
class AppDependencies extends StatefulWidget {
  final App app;

  const AppDependencies({required this.app, Key? key}) : super(key: key);

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  late final DefaultErrorHandler _defaultErrorHandler;
  late final INoteRepository _noteRepository;
  late final NoteListScreenModel _noteListScreenModel;

  late final ThemeWrapper _themeWrapper;

  @override
  void initState() {
    super.initState();

    _defaultErrorHandler = DefaultErrorHandler();
    // TODO(Zemcov): Замени на файрбэйс
    // _noteRepository = TempLocalNoteRepository();
    _noteRepository = CloudFirestoreNoteRepository();

    _noteListScreenModel = NoteListScreenModel(
      _noteRepository,
      _defaultErrorHandler,
    );

    _themeWrapper = ThemeWrapper();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NoteListScreenModel>(
          create: (_) => _noteListScreenModel,
        ),
        Provider<ThemeWrapper>(
          create: (_) => _themeWrapper,
        ),
      ],
      child: widget.app,
    );
  }
}
