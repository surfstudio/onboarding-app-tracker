import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Note.fromDatabase(QueryDocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>?;
    return Note(
      id: document.id,
      title: data?['title'] as String,
      startTimestamp: data?['startTimestamp'] as int,
      endTimestamp: data?['endTimestamp'] as int?,
    );
  }

  DateTime? startDateTime() => DateTime.fromMicrosecondsSinceEpoch(
        startTimestamp * 1000,
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
      return endDateTime()?.difference(startDateTime() ?? DateTime.now());
    }
  }
}
