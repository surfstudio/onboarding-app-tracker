import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';

class TempLocalNoteRepository implements INoteRepository {
  final _data = <Note>[];

  TempLocalNoteRepository() {
    _data.addAll(_mockData);
  }

  @override
  Future<List<Note>> loadAllNotes() async {
    await _addDuration();
    return _data;
  }

  @override
  Future<List<Note>> addNote(Note newNote) async {
    await _addDuration();
    return _data..add(newNote);
  }

  @override
  Future<List<Note>> deleteNote(String noteId) async {
    await _addDuration();
    _addException(howOften: 2);
    _checkElementInList(noteId);
    return _data..removeWhere((note) => note.id == noteId);
  }

  @override
  Future<List<Note>> editNote({
    required String noteId,
    required Note newNoteData,
  }) async {
    await _addDuration();
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

  /// For the network behavior imitation
  Future<void> _addDuration() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  // TODO(Zemcov): Переменная для тестирования ошибки. Удали когда наиграешься
  int DELETE_IT_Index = 0;
  void _addException({int howOften = 1}) {
    DELETE_IT_Index++;
    if (DELETE_IT_Index % howOften == 0) {
      throw Exception('Иммитация ошибки сервера');
    }
  }
}

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
