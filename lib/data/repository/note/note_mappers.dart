import 'package:time_tracker/data/dto/note/note_data.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/res/theme/app_colors.dart';

/// Map Note from NoteData
List<Note> mapNoteDataListToNoteList(List<NoteData> noteDataList) {
  final result = <Note>[];
  for (var i = 0; i < noteDataList.length; i++) {
    final haveNextNote = i + 1 < noteDataList.length;
    final eventDuration = !haveNextNote
        ? null
        : noteDataList
            .elementAt(i + 1)
            .dateTime
            .difference(noteDataList.elementAt(i).dateTime);
    final formattedDuration =
        eventDuration == null ? null : formatDuration(eventDuration);
    result.add(
      Note(
        title: noteDataList.elementAt(i).title,
        eventDuration:
            eventDuration == null ? null : 'потрачено $formattedDuration',
        statusColor: AppColors.accentValues.elementAt(
          i % AppColors.accentValues.length,
        ),
      ),
    );
  }
  return result;
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return '${twoDigits(duration.inHours)} час ${twoDigitMinutes == '00' ? '' : '$twoDigitMinutes мин'}';
}
