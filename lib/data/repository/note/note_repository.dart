import 'package:time_tracker/data/api/note/note_client.dart';
import 'package:time_tracker/data/repository/note/note_mappers.dart';
import 'package:time_tracker/domain/note/note.dart';

/// Note repository
class NoteRepository {
  final NoteClient _client;

  NoteRepository(this._client);

  /// Return all notes
  Future<Iterable<Note>> getAllNotes() async {
    final noteDataList = await _client.getAll();
    return mapNoteDataListToNoteList(noteDataList);
  }
}
