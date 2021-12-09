import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  factory Note({
    required String id,
    required String title,
    required int startTimestamp,
    int? endTimestamp,
  }) = _Note;

  const Note._();

  DateTime? startDateTime() => DateTime.fromMicrosecondsSinceEpoch(
        (startTimestamp as int) * 1000,
      );

  DateTime? endDateTime() {
    if (endTimestamp != null) {
      return DateTime.fromMicrosecondsSinceEpoch(
        (endTimestamp as int) * 1000,
      );
    }
  }

  Duration? noteDuration() {
    if (endTimestamp != null) {
      return startDateTime()?.difference(endDateTime() ?? DateTime.now());
    }
  }
}
