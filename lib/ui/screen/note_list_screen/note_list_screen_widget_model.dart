import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_model.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen.dart';
import 'package:time_tracker/ui/widgets/dialog/input_dialog.dart';
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
  final _listScrollController = ScrollController();

  @override
  ListenableState<EntityState<List<Note>>> get noteListState => _noteListState;

  ScrollController get listScrollController => _listScrollController;

  NoteListScreenWidgetModel(
    NoteListScreenModel model,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    noteStreamSubscription = model.noteStream.listen(_noteStreamListener);
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
    // TODO(Bazarova): добавь обработчик ошибок (с компьютерного на человеческий)
    showSimpleSnackBar(error.toString());
  }

  @override
  Future<void> loadAllNotes() async {
    final previousState = _noteListState.value?.data;
    _noteListState.loading();
    try {
      final sortedNotes = await model.loadAllNotes()
        ..sort();
      _noteListState.content(sortedNotes);
    } on Exception catch (e) {
      _noteListState.error(e, previousState);
    }
  }

  // ToDo(Bazarova): грязная функция
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
      }
    }
  }

  @override
  void onTapTags() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const TagListScreen()),
    );
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
  Future<void> showAddNoteDialog() async => showDialog<void>(
        context: context,
        builder: (context) {
          String? title;

          void onChanged(String inputText) => title = inputText;

          void onSubmit() {
            if (title != null) {
              final newNote = Note(
                startTimestamp: DateTime.now().millisecondsSinceEpoch,
                id: 'default',
                title: title!,
              );
              Navigator.pop(context);
              _addNoteAndFinishTheLastNote(newNote);
            }
          }

          return InputDialog(
            onChanged: onChanged,
            onSubmit: onSubmit,
            title: 'Введите название задачи',
            submitButtonText: 'Ввести',
          );
        },
      );

  void _noteStreamListener(QuerySnapshot snapshot) {
    final notes = snapshot.docs
        .map((rawNote) => Note.fromDatabase(rawNote))
        .toList()
      ..sort();
    _noteListState.content(notes);
  }

  Future<void> _finishNote(Note newNote) async {
    final notesCount = _noteListState.value?.data?.length ?? 0;
    if (notesCount > 1) {
      await model.finishNote(
        newNote.startTimestamp,
      );
    }
  }

  // ToDo(Bazarova): грязная функция
  Future<void> _addNoteAndFinishTheLastNote(Note newNote) async {
    await _finishNote(newNote);
    await _addNote(newNote);
  }

  Future<void> _addNote(Note newNote) async {
    _noteListState.value?.data?.add(newNote);

    final newState = (_noteListState.value?.data?..sort()) ?? [];
    _noteListState.content(newState);

    try {
      await model.addNote(newNote);
    } on Exception catch (_) {
      final currentState = (_noteListState.value?.data ?? [newNote])
        ..remove(newNote);
      _noteListState.content(currentState);
    }
  }
}
