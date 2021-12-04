import 'package:flutter/material.dart';

/// Note model.
class Note {
  final String id;
  final String title;
  final DateTime startDateTime;
  final DateTime? endDateTime;

  String? get eventDuration => _rawEventDuration == null
      ? null
      : _formatDurationToString(_rawEventDuration!);

  // TODO(Zemcov): сделай динамическую расцветку
  Color? get statusColor => Colors.brown;

  Duration? get _rawEventDuration => endDateTime?.difference(startDateTime);

  Note({
    required this.id,
    required this.title,
    required this.startDateTime,
    this.endDateTime,
  });

  Note copyWith({
    String? id,
    String? title,
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
      );

  String _formatDurationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)} час $twoDigitMinutes мин $twoDigitSeconds сек';
  }
}
