import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_model.dart';
import 'package:time_tracker/ui/screen/note_list_screen/widgets/input_note_dialog.dart';
import 'package:time_tracker/ui/widgets/snackbar/snack_bars.dart';

part 'i_note_list_widget_model.dart';

/// Factory for [NoteListScreenWidgetModel]
NoteListScreenWidgetModel noteListScreenWidgetModelFactory(
  BuildContext context,
) {
  final model = context.read<NoteListScreenModel>();
  return NoteListScreenWidgetModel(model);
}

/// Widget Model for [NoteListScreen]
class NoteListScreenWidgetModel
    extends WidgetModel<NoteListScreen, NoteListScreenModel>
    implements INoteListWidgetModel {
  late final StreamSubscription noteStreamSubscription;
  final _noteListState = EntityStateNotifier<List<Note>>();
  final ScrollController _listScrollController = ScrollController();

  @override
  ListenableState<EntityState<List<Note>>> get noteListState => _noteListState;

  ScrollController get listScrollController => _listScrollController;

  NoteListScreenWidgetModel(
    NoteListScreenModel model,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    noteStreamSubscription = model.noteStream.listen((QuerySnapshot snapshot) {
      final docs = snapshot.docs;
      final notes = docs.map((doc) => Note.fromDatabase(doc)).toList();
      _noteListState.content(notes);
    });
  }
  
  @override
  void dispose() {
    noteStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);
    hideCurrentSnackBar();
    // TODO(Zemcov): добавь обработчик ошибок (с компьютерного на человеческий)
    showSimpleSnackBar(error.toString());
  }

  @override
  Future<void> loadAllNotes() async {
    final previousData = _noteListState.value?.data;
    try {
      final res = await model.loadAllNotes();
      _noteListState.content(res);
    } on Exception catch (e) {
      _noteListState.error(e, previousData);
    }
  }

  @override
  Future<Note?> moveNoteToTrash(int index) async {
    final previousData = _noteListState.value?.data;
    if (previousData == null) {
      return null;
    }
    final deletingNote = previousData.elementAt(index);
    final optimisticData = [...previousData]..remove(deletingNote);
    _noteListState.content(optimisticData);
    try {
      await model.moveNoteToTrash(deletingNote.id);
      return deletingNote;
    } on Exception catch (_) {
      final newActualData = (_noteListState.value?.data ?? [])
        ..add(deletingNote)
        ..sort(_sortByStartDateTimeCallback);
      _noteListState.content(newActualData);
      return null;
    }
  }

  @override
  Future<void> showCancelDeleteSnackBar(Note deletedNote) async {
    hideCurrentSnackBar();
    await showRevertSnackBar(
      title: 'Заметка ${deletedNote.title} удалена',
      onRevert: () async => _restoreNoteOptimistic(deletedNote),
    )?.closed;
  }

  @override
  Future<void> showAddNoteDialog() async {
    final previousData = _noteListState.value?.data;
    final lastNote = (previousData ?? []).isEmpty ? null : previousData?.last;
    await _showAddNoteDialog(lastNote);
  }

  Future<void> _showAddNoteDialog(Note? lastNote) => showDialog<void>(
        context: context,
        builder: (context) {
          String? title;

          void onChanged(String s) => title = s;

          void onSubmit() {
            if (title == null) {
              return;
            }
            final newNote = Note(
              startTimestamp: DateTime.now().millisecondsSinceEpoch,
              id: 'default',
              title: title!,
            );
            Navigator.pop(context);
            _addNote(newNote);
            _finishNote(newNote);
          }

          return InputNoteDialog(onChanged: onChanged, onSubmit: onSubmit);
        },
      );

  Future<void> _finishNote(Note newNote) async {
    if ((_noteListState.value?.data?.length ?? 0) > 1) {
      await model.finishNote(
        newNote.startTimestamp,
      );
    }
  }

  Future<void> _addNote(Note newNote) async {
    _noteListState.value?.data?.add(newNote);
    final optimisticData = _noteListState.value?.data;
    _noteListState.content(optimisticData!);
    try {
      await model.addNote(newNote);
    } on Exception catch (_) {
      final newActualData = (_noteListState.value?.data ?? [newNote])
        ..remove(newNote);
      _noteListState.content(newActualData);
    }
  }

  Future<void> _restoreNoteOptimistic(Note deletedNote) async {
    final previousData = _noteListState.value?.data;
    final optimisticData = <Note>[...previousData ?? [], deletedNote]
      ..sort(_sortByStartDateTimeCallback);
    _noteListState.content(optimisticData);
    try {
      await model.restoreNote(deletedNote.id);
    } on Exception catch (_) {
      final newActualData = (_noteListState.value?.data ?? [deletedNote])
        ..remove(deletedNote);
      _noteListState.content(newActualData);
    }
  }

  int _sortByStartDateTimeCallback(Note a, Note b) {
    final startTimeNoteA = a.startDateTime() ?? DateTime.now();
    final startTimeNoteB = b.startDateTime() ?? DateTime.now();

    return startTimeNoteA.compareTo(startTimeNoteB);
  }
}
