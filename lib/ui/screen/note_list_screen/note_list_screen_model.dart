import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';

/// Model for [NoteListScreen]
class NoteListScreenModel extends ElementaryModel {
  late final Stream<QuerySnapshot> noteStream;
  final INoteRepository _noteRepository;

  NoteListScreenModel(
    this._noteRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler) {
    noteStream = _noteRepository.noteStream;
  }

  Future<List<Note>> loadAllNotes() async {
    try {
      return await _noteRepository.loadAllNotes();
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _noteRepository.addNote(note);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> finishNote(int endTimestamp) async {
    try {
      await _noteRepository.finishNote(endTimestamp);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _noteRepository.deleteNote(note);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> editNote({
    required String noteId,
    required Note newNoteData,
  }) async {
    try {
      await _noteRepository.editNote(
        noteId: noteId,
        newNoteData: newNoteData,
      );
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
