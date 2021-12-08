import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/domain/note.dart';
import 'package:time_tracker/res/theme/app_edge_insets.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_model.dart';
import 'package:time_tracker/utils/snack_bars.dart';
import 'package:uuid/uuid.dart';

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
  final _noteListState = EntityStateNotifier<List<Note>>();

  @override
  ListenableState<EntityState<List<Note>>> get noteListState => _noteListState;

  NoteListScreenWidgetModel(
    NoteListScreenModel model,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    loadAllNotes();
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

  // TODO(Z): Лучше ждать выполнение запроса. И не удалять а перемещать в коллекцию удаленных.
  @override
  Future<void> deleteNote(int index) async {
    final previousData = _noteListState.value?.data;
    if (previousData == null) {
      return;
    }
    final deletingNote = previousData.elementAt(index);
    final optimisticData = [...previousData]..remove(deletingNote);
    _noteListState.content(optimisticData);
    final isConfirm = await _getConfirmFromSnackBar();
    if (!isConfirm) {
      _noteListState.content(previousData);
      return;
    }
    try {
      await model.deleteNote(deletingNote.id);
      // TODO(Question): Отрабатывает криво если удалять сразу несколько заметок
      // _noteListState.content(resultList);
    } on Exception catch (_) {
      // TODO(Question): При быстром удалении нескольких заметок обработка ошибки возращает неактуальные данные.
      // Например при быстром удалении 5 заменток и возникновении обибки на 3 заметке
      // на экране останется 3, 4 и 5 заметка, не смотря на то, что в репозитории
      // осталась только 3 заметка
      _noteListState.content(previousData);
    }
  }

  @override
  Future<void> addNoteWithDialogAndUpdateLastNote() async {
    final previousData = _noteListState.value?.data;
    final lastNote = (previousData ?? []).isEmpty ? null : previousData?.last;
    final newNote = await _getNoteByDialog();
    if (newNote == null) {
      return;
    }
    unawaited(_addNote(newNote));
    if (lastNote == null || lastNote.endDateTime != null) {
      return;
    }
    unawaited(_editNote(
      lastNote.id,
      lastNote.copyWith(endDateTime: DateTime.now()),
    ));
  }

  Future<void> _addNote(Note newNote) async {
    final previousData = _noteListState.value?.data;
    final optimisticData = <Note>[...previousData ?? [], newNote];
    _noteListState.content(optimisticData);
    try {
      await model.addNote(newNote);
    } on Exception catch (_) {
      _noteListState.content(previousData ?? []);
    }
  }

  Future<void> _editNote(String noteId, Note newNoteData) async {
    final previousData = _noteListState.value?.data;
    final index = (previousData ?? []).indexWhere((e) => e.id == noteId);
    if (index == -1) {
      return;
    }
    final optimisticData = <Note>[...previousData ?? []]..[index] = newNoteData;
    _noteListState.content(optimisticData);
    try {
      await model.editNote(
        noteId: noteId,
        newNoteData: newNoteData,
      );
    } on Exception catch (_) {
      _noteListState.content(previousData ?? []);
    }
  }

  Future<bool> _getConfirmFromSnackBar() async {
    var isConfirm = true;
    hideCurrentSnackBar();
    await showRevertSnackBar(
      onRevert: (isReverted) => isConfirm = !isReverted,
    )?.closed;
    return isConfirm;
  }

  Future<Note?> _getNoteByDialog() => showDialog<Note?>(
        context: context,
        builder: (context) {
          const uuid = Uuid();
          String? title;
          // TODO(Zemcov): техдолг. Вынести в библиотеку виджетов
          return SimpleDialog(
            contentPadding: AppEdgeInsets.b10h20,
            title: const Text('Ввидите название задачи'),
            children: [
              TextFormField(
                onChanged: (s) => title = s,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        title == null
                            ? null
                            : Note(
                                startDateTime: DateTime.now(),
                                id: uuid.v1(),
                                title: title!,
                              ),
                      );
                    },
                    child: const Text('Ввести'),
                  ),
                ],
              ),
            ],
          );
        },
      );
}
