import 'package:flutter/material.dart';
import 'package:time_tracker/res/theme/app_colors.dart';

/// Note model.
class Note {
  final String id;
  final String title;
  final DateTime startDateTime;
  final DateTime? endDateTime;
  _NoteDuration? get noteDuration =>
      _noteDuration == null ? null : _NoteDuration(_noteDuration!);
  Duration? get _noteDuration => endDateTime?.difference(startDateTime);

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'startDateTime': startDateTime.millisecondsSinceEpoch,
      'endDateTime': endDateTime?.millisecondsSinceEpoch,
    };
  }
}

class _NoteDuration {
  final Duration noteDuration;

  String get title => _durationToString(noteDuration);

  /// The [color] depends on the [noteDuration] value.
  Color get color {
    if (noteDuration.inHours > 2) {
      return AppColors.noteDuration.elementAt(2);
    }
    if (noteDuration.inMinutes > 30) {
      return AppColors.noteDuration.elementAt(1);
    }
    return AppColors.noteDuration.elementAt(0);
  }

  _NoteDuration(this.noteDuration);

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitHours = twoDigits(duration.inHours);
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String format(String twoDigits, String description) {
      if (twoDigits == '00') {
        return '';
      }
      return '$twoDigits $description';
    }

    return ' ${format(twoDigitHours, 'час ')}${format(twoDigitMinutes, 'мин ')}${format(twoDigitSeconds, 'сек ')}';
  }
}
