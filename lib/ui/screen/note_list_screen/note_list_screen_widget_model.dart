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
      final notes = docs.map((doc) => Note.fromDatabase(doc)).toList()
        ..sort(_sortByStartDateTimeCallback);
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
    // TODO(vasbaza): добавь обработчик ошибок (с компьютерного на человеческий)
    showSimpleSnackBar(error.toString());
  }

  @override
  Future<void> loadAllNotes() async {
    final previousData = _noteListState.value?.data;
    try {
      final res = await model.loadAllNotes()
        ..sort(_sortByStartDateTimeCallback);
      _noteListState.content(res);
    } on Exception catch (e) {
      _noteListState.error(e, previousData);
    }
  }

  // ToDo(vasbaza): грязная функция, помыть ее
  @override
  Future<Note?> moveNoteToTrash(int index) async {
    final noteToDelete = _noteListState.value?.data?.elementAt(index);
    _noteListState.value?.data?.remove(noteToDelete);
    final newState = _noteListState.value?.data;
    if (newState != null) {
      _noteListState.content(newState);
    }
    if (noteToDelete != null) {
      await model.deleteNote(noteToDelete);
      final shouldDelete = await showCancelDeleteSnackBar(noteToDelete);
      if (shouldDelete) {
      } else {
        await _addNote(noteToDelete);
        _noteListState.value?.data?.add(noteToDelete);
        final newState = _noteListState.value?.data
          ?..sort(_sortByStartDateTimeCallback);
        if (newState != null) {
          _noteListState.content(newState);
        }
      }
    }
  }

  @override
  Future<bool> showCancelDeleteSnackBar(Note deletedNote) async {
    var shouldDelete = true;
    hideCurrentSnackBar();
    await showRevertSnackBar(
      title: 'Заметка ${deletedNote.title} удалена',
      onRevert: () => shouldDelete = false,
    )?.closed;
    return shouldDelete;
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
            _addNoteAndFinishTheLastNote(newNote);
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

  // ToDo(vasbaza): грязная функция
  Future<void> _addNoteAndFinishTheLastNote(Note newNote) async {
    await _finishNote(newNote);
    await _addNote(newNote);
  }

  Future<void> _addNote(Note newNote) async {
    _noteListState.value?.data?.add(newNote);
    final optimisticData = _noteListState.value?.data
      ?..sort(_sortByStartDateTimeCallback);
    _noteListState.content(optimisticData!);
    try {
      // await _finishNote(newNote);
      await model.addNote(newNote);
    } on Exception catch (_) {
      final newActualData = (_noteListState.value?.data ?? [newNote])
        ..remove(newNote);
      _noteListState.content(newActualData);
    }
  }


  int _sortByStartDateTimeCallback(Note a, Note b) {
    final startTimeNoteA = a.startDateTime() ?? DateTime.now();
    final startTimeNoteB = b.startDateTime() ?? DateTime.now();

    return startTimeNoteA.compareTo(startTimeNoteB);
  }
}
