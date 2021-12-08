import 'package:time_tracker/domain/note.dart';

abstract class INoteRepository {
  /// Return all notes
  Future<List<Note>> loadAllNotes();

  /// Add a new note
  Future<void> addNote(Note note);

  /// Delete note by id
  Future<void> deleteNote(String noteId);

  /// Edit note data by id
  Future<void> editNote({
    required String noteId,
    required Note newNoteData,
  });
}
