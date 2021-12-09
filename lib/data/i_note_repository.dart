import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/domain/note/note.dart';

abstract class INoteRepository {
  Stream<QuerySnapshot> get noteStream;

  /// Return all notes
  Future<List<Note>> loadAllNotes();

  Future<void> finishNote(int endTimestamp);

  /// Add a new note
  Future<void> addNote(Note note);

  /// Delete note by id
  Future<void> moveNoteToTrash(String noteId);

  Future<void> restoreNote(String noteId);

  /// Edit note data by id
  Future<void> editNote({
    required String noteId,
    required Note newNoteData,
  });
}
