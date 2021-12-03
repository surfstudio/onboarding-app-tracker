import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/res/theme/app_typography.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_model.dart';

/// Factory for [NoteListScreenWidgetModel]
NoteListScreenWidgetModel noteListScreenWidgetModelFactory(
  BuildContext context,
) {
  final model = context.read<NoteListScreenModel>();
  final theme = context.read<ThemeWrapper>();
  return NoteListScreenWidgetModel(model, theme);
}

/// Widget Model for [NoteListScreen]
class NoteListScreenWidgetModel
    extends WidgetModel<NoteListScreen, NoteListScreenModel>
    implements INoteListWidgetModel {
  final ThemeWrapper _themeWrapper;

  final _noteListState = EntityStateNotifier<Iterable<Note>>();
  late TextStyle _noteNameStyle;

  @override
  ListenableState<EntityState<Iterable<Note>>> get noteListState =>
      _noteListState;

  @override
  TextStyle get noteNameStyle => _noteNameStyle;

  NoteListScreenWidgetModel(
    NoteListScreenModel model,
    this._themeWrapper,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _loadNoteList();
    _noteNameStyle = AppTypography.cardTitle;
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);
    // TODO(Zemcov): добавь обработку
    // if (error is DioError &&
    //     (error.type == DioErrorType.connectTimeout ||
    //         error.type == DioErrorType.receiveTimeout)) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text('Connection troubles')));
    // }
  }

  Future<void> _loadNoteList() async {
    final previousData = _noteListState.value?.data;
    _noteListState.loading(previousData);

    try {
      final res = await model.loadNotes();
      _noteListState.content(res);
    } on Exception catch (e) {
      _noteListState.error(e, previousData);
    }
  }

  @override
  void addNote() {
    throw Exception('Метод добавления не реализован');
  }
}

/// Interface of [NoteListScreenWidgetModel]
abstract class INoteListWidgetModel extends IWidgetModel {
  ListenableState<EntityState<Iterable<Note>>> get noteListState;

  TextStyle get noteNameStyle;

  void addNote();
}
