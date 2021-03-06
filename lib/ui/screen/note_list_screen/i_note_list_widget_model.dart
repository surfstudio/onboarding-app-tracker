part of 'note_list_screen_widget_model.dart';

/// Interface of [NoteListScreenWidgetModel]
abstract class INoteListWidgetModel extends IWidgetModel {
  ListenableState<EntityState<List<Note>>> get noteListState;

  Future<void> loadAllNotes();

  Future<Note?> moveNoteToTrash(int index);

  Future<void> showCancelDeleteSnackBar(Note deletedNote);

  Future<void> showAddNoteDialog();

  Future<void> showEditNoteDialog(Note noteToEdit);

  void onTapTags();
}
