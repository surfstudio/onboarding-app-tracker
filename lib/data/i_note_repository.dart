import 'package:time_tracker/domain/note.dart';

abstract class INoteRepository {
  /// Return all notes
  Future<Iterable<Note>> loadAllNotes();

  /// Add a new note
  Future<List<Note>> addNote(Note note);

  /// Delete note by id
  Future<List<Note>> deleteNote(String noteId);

  /// Edit note data by id
  Future<List<Note>> editNote({
    required String noteId,
    required Note newNoteData,
  });
}
