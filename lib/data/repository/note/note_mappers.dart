import 'package:time_tracker/data/dto/note/note_data.dart';
import 'package:time_tracker/domain/note/note.dart';

/// Map Note from NoteData
Note mapNote(NoteData data) {
  return Note(
    title: data.title,
    dateTime: data.dateTime,
  );
}
