part of 'note_list_screen_widget_model.dart';

/// Interface of [NoteListScreenWidgetModel]
abstract class INoteListWidgetModel extends IWidgetModel {
  ListenableState<EntityState<List<Note>>> get noteListState;

  Future<void> loadAllNotes();

  void addNoteWithDialogAndUpdateLastNote();

  void deleteNote(int index);
}
