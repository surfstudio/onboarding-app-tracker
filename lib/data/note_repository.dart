import 'package:time_tracker/domain/note/note.dart';

/// Note repository
class MockNoteRepository {
// TODO(Zemcov): Прокинь в репузиторий firebace клиент
  MockNoteRepository();

  /// Return all notes
  Future<Iterable<Note>> getAllNotes() async {
    return _mockData;
  }
}

final List<Note> _mockData = [
  Note(
    title: 'Созвон',
    startDateTime: DateTime(2021, 12, 2, 9),
    endDateTime: DateTime(2021, 12, 2, 10),
  ),
  Note(
    title: 'Прогаю',
    startDateTime: DateTime(2021, 12, 2, 10),
    endDateTime: DateTime(2021, 12, 2, 13),
  ),
  Note(
    title: 'Обед',
    startDateTime: DateTime(2021, 12, 2, 13),
    endDateTime: DateTime(2021, 12, 2, 14),
  ),
  Note(
    title: 'Прогаю',
    startDateTime: DateTime(2021, 12, 2, 14),
    endDateTime: DateTime(2021, 12, 2, 18, 15),
  ),
  Note(
    title: 'Списываю время',
    startDateTime: DateTime(2021, 12, 2, 18, 15),
    endDateTime: null,
  ),
];
