import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/domain/note/note.dart';

abstract class INoteRepository {
  /// Real-time changes in notes stream
  Stream<QuerySnapshot> createNoteStream(String userId);

  /// Return all notes
  Future<List<Note>> loadAllNotes(String userId);

  /// Finishes last note (before new note)
  Future<void> finishNote(String userId, int endTimestamp);

  /// Add a new note
  Future<void> addNote(String userId, Note note);

  /// Delete note by id
  Future<void> deleteNote(String userId, Note note);

  /// Edit note data by id
  Future<void> editNote({
    required String userId,
    required String noteId,
    required Map<String, dynamic> newNoteData,
  });
}
