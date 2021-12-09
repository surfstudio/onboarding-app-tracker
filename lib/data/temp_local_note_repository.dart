import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';

class TempLocalNoteRepository implements INoteRepository {
  final _data = <Note>[];

  final _NetworkBehaviourImitation _networkImitation =
      _NetworkBehaviourImitation();

  TempLocalNoteRepository() {
    _data.addAll(_networkImitation._mockData);
  }

  @override
  Future<List<Note>> loadAllNotes() async {
    await _networkImitation.addDuration();
    return _data..sort(_sortByStartDateTimeCallback);
  }

  @override
  Future<List<Note>> addNote(Note newNote) async {
    await _networkImitation.addDuration();
    _networkImitation.addException(howOften: 3);
    return _data..add(newNote);
  }

  @override
  Future<List<Note>> deleteNote(String noteId) async {
    await _networkImitation.addDuration();
    _networkImitation.addException(howOften: 3);
    _checkElementInList(noteId);
    return _data..removeWhere((note) => note.id == noteId);
  }

  @override
  Future<List<Note>> editNote({
    required String noteId,
    required Note newNoteData,
  }) async {
    await _networkImitation.addDuration();
    _checkElementInList(noteId);
    _data[_getIndexById(noteId)] = newNoteData;
    return _data;
  }

  int _getIndexById(String noteId) {
    return _data.indexWhere((note) => note.id == noteId);
  }

  void _checkElementInList(String noteId) {
    if (!_data.any((note) => note.id == noteId)) {
      throw Exception('Element not found');
    }
  }

  int _sortByStartDateTimeCallback(Note a, Note b) =>
      (a.startDateTime ?? DateTime.now())
          .compareTo(b.startDateTime ?? DateTime.now());
}

/// Класс используется для отлидки
class _NetworkBehaviourImitation {
  final List<Note> _mockData = [
    Note(
      title: 'Созвон',
      startDateTime: DateTime(2021, 12, 2, 9),
      endDateTime: DateTime(2021, 12, 2, 10),
      id: '0',
    ),
    Note(
      title: 'Прогаю',
      startDateTime: DateTime(2021, 12, 2, 10),
      endDateTime: DateTime(2021, 12, 2, 13),
      id: '1',
    ),
    Note(
      title: 'Обед',
      startDateTime: DateTime(2021, 12, 2, 13),
      endDateTime: DateTime(2021, 12, 2, 14),
      id: '2',
    ),
    Note(
      title: 'Прогаю',
      startDateTime: DateTime(2021, 12, 2, 14),
      endDateTime: DateTime(2021, 12, 2, 18, 15),
      id: '3',
    ),
    Note(
      title: 'Списываю время',
      startDateTime: DateTime(2021, 12, 2, 18, 15),
      id: '4',
    ),
  ];

  int requestCount = 0;

  void addException({
    int howOften = 1,
    String? message,
  }) {
    requestCount++;
    if (requestCount % howOften == 0) {
      throw Exception(
        message ??
            'Имитация ошибки сервера: '
                'ошибка воспроизводится каждый $howOften запрос',
      );
    }
  }

  Future<void> addDuration({
    Duration duration = const Duration(seconds: 1),
  }) async {
    await Future<void>.delayed(duration);
  }
}
