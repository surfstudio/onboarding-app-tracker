import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/domain/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_model.dart';

part 'i_note_list_widget_model.dart';

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
  final _noteListState = EntityStateNotifier<List<Note>>();

  @override
  ListenableState<EntityState<List<Note>>> get noteListState => _noteListState;

  NoteListScreenWidgetModel(
    NoteListScreenModel model,
    this._themeWrapper,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _loadNoteList();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);
    // TODO(Zemcov): добавь обработку ошибок
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
    // }
  }

  @override
  Future<void> addNote() async {
    // TODO(Zemcov): вызвать пользовательский ввод, получить экземпляр заметки
    final newNote = Note(
      id: '1231',
      endDateTime: null,
      title: 'Test Note',
      startDateTime: DateTime.now(),
    );

    final previousData = _noteListState.value?.data;
    final optimisticData = <Note>[...previousData ?? [], newNote];
    _noteListState.content(optimisticData);

    try {
      final resultList = await model.addNote(newNote);
      _noteListState.content(resultList);
    } on Exception catch (_) {
      _noteListState.content(previousData ?? []);
    }
  }

  Future<void> _loadNoteList() async {
    final previousData = _noteListState.value?.data;
    try {
      final res = await model.loadAllNotes();
      _noteListState.content(res);
    } on Exception catch (e) {
      _noteListState.error(e, previousData);
    }
  }
}
