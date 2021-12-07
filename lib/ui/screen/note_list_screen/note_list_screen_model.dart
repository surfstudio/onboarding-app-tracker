import 'package:elementary/elementary.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';

/// Model for [NoteListScreen]
class NoteListScreenModel extends ElementaryModel implements INoteRepository {
  final INoteRepository _noteRepository;

  NoteListScreenModel(
    this._noteRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  Future<List<Note>> loadAllNotes() async {
    try {
      return await _noteRepository.loadAllNotes();
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
  Future<void> addNote(Note note) async {
    try {
      await _noteRepository.addNote(note);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      await _noteRepository.deleteNote(noteId);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
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
