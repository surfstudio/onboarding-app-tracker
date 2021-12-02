import 'package:flutter/material.dart';

/// Note model.
class Note {
  final String title;
  final String? eventDuration;
  final Color? statusColor;

  Note({
    required this.title,
    required this.eventDuration,
    required this.statusColor,
  });
}
