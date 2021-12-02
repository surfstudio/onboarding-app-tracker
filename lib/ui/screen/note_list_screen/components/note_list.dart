import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/error_widget.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/note_widget.dart';

class NoteList extends StatelessWidget {
  final Iterable<Note>? notes;
  final TextStyle nameStyle;

  const NoteList({
    Key? key,
    required this.notes,
    required this.nameStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = this.notes;

    if (notes == null || notes.isEmpty) {
      return const LoadingErrorWidget();
    }

    return ListView.separated(
      itemBuilder: (_, index) => NoteWidget(
        data: notes.elementAt(index),
        noteNameStyle: nameStyle,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: notes.length,
    );
  }
}
