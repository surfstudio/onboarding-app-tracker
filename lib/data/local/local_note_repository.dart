import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';

class TempLocalNoteRepository implements INoteRepository {
  final _noteList = <Note>[];

  final _NetworkBehaviourImitation _networkImitation =
      _NetworkBehaviourImitation();

  @override
  // TODO(Bazarova): implement noteStream
  Stream<QuerySnapshot> get noteStream => throw UnimplementedError();

  TempLocalNoteRepository() {
    _noteList.addAll(_networkImitation._mockData);
  }

  @override
  Future<List<Note>> loadAllNotes(String userId) async {
    await _networkImitation.addDuration();
    return _noteList..sort(_sortByStartDateTimeCallback);
  }

  @override
  Future<void> addNote(String userId, Note newNote) async {
    await _networkImitation.addDuration();
    _networkImitation.addException(howOften: 3);
    _noteList.add(newNote);
  }

  @override
  Future<void> deleteNote(String userId, Note note) async {}

  @override
  Future<List<Note>> editNote({
    required String userId,
    required Note updatedNote,
  }) async {
    await _networkImitation.addDuration();
    return _noteList;
  }

  @override
  Future<void> finishNote(String userId, int endTimestamp) {
    // TODO(Bazarova): implement finishNote
    throw UnimplementedError();
  }

  @override
  Stream<List<Note>> createNoteStream(String userId) {
    // TODO(Bazarova): implement createNoteStream
    throw UnimplementedError();
  }

  int _sortByStartDateTimeCallback(Note a, Note b) {
    final startTimeNoteA = a.startDateTime;
    final startTimeNoteB = b.startDateTime;
    return startTimeNoteA.compareTo(startTimeNoteB);
  }
}

/// Класс используется для отлидки
class _NetworkBehaviourImitation {
  final List<Note> _mockData = [
    Note(
      title: 'Созвон',
      startTimestamp: DateTime(2021, 12, 2, 9).microsecondsSinceEpoch,
      endTimestamp: DateTime(2021, 12, 2, 10).microsecondsSinceEpoch,
      id: '0',
    ),
    Note(
      title: 'Прогаю',
      startTimestamp: DateTime(2021, 12, 2, 10).microsecondsSinceEpoch,
      endTimestamp: DateTime(2021, 12, 2, 13).microsecondsSinceEpoch,
      id: '1',
    ),
    Note(
      title: 'Обед',
      startTimestamp: DateTime(2021, 12, 2, 13).microsecondsSinceEpoch,
      endTimestamp: DateTime(2021, 12, 2, 14).microsecondsSinceEpoch,
      id: '2',
    ),
    Note(
      title: 'Прогаю',
      startTimestamp: DateTime(2021, 12, 2, 14).microsecondsSinceEpoch,
      endTimestamp: DateTime(2021, 12, 2, 18, 15).microsecondsSinceEpoch,
      id: '3',
    ),
    Note(
      title: 'Списываю время',
      startTimestamp: DateTime(2021, 12, 2, 18, 15).microsecondsSinceEpoch,
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
