import 'package:elementary/elementary.dart';
import 'package:time_tracker/data/repository/note/note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';

/// Model for [NoteListScreen]
class NoteListScreenModel extends ElementaryModel {
  final NoteRepository _noteRepository;

  NoteListScreenModel(
    this._noteRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Return iterable notes.
  Future<Iterable<Note>> loadCountries() async {
    try {
      final res = await _noteRepository.getAllCountries();
      return res;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
