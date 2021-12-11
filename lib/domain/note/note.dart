import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_tracker/domain/tag/tag.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note implements Comparable<Note> {
  DateTime get startDateTime => DateTime.fromMicrosecondsSinceEpoch(
        startTimestamp * 1000,
      );

  DateTime? get endDateTime {
    if (endTimestamp != null) {
      return DateTime.fromMicrosecondsSinceEpoch(
        (endTimestamp as int) * 1000,
      );
    }
  }

  Duration get noteDuration {
    final resolvedEndTimestamp = endDateTime ?? DateTime.now();

    return resolvedEndTimestamp.difference(startDateTime);
  }

  bool get isFinished => endTimestamp != null;

  factory Note({
    required String id,
    required String title,
    required int startTimestamp,
    int? endTimestamp,
    Tag? tag,
  }) = _Note;

  const Note._();

  factory Note.fromDatabase(QueryDocumentSnapshot document) {
    final rawNote = document.data() as Map<String, dynamic>?;
    final rawTag = rawNote?['tag'] as Map<String, dynamic>?;
    return Note(
      id: document.id,
      title: rawNote?['title'] as String,
      tag: Tag(
        title: (rawTag?['title'] ?? '') as String,
        id: (rawTag?['id'] ?? '') as String,
      ),
      startTimestamp: rawNote?['startTimestamp'] as int,
      endTimestamp: rawNote?['endTimestamp'] as int?,
    );
  }

  @override
  int compareTo(Note other) {
    final otherStartTime = other.startDateTime;
    return startDateTime.compareTo(otherStartTime);
  }
}
