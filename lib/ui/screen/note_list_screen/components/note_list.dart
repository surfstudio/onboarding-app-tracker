import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/empty_list_widget.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/error_widget.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/note_widget.dart';

class NoteList extends StatelessWidget {
  final List<Note>? notes;

  const NoteList({
    required this.notes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = this.notes;

    if (notes == null) {
      return const LoadingErrorWidget();
    }
    if (notes.isEmpty) return const EmptyListWidget();

    return ListView.builder(
      itemBuilder: (_, index) => NoteWidget(
        note: notes.elementAt(index),
      ),
      itemCount: notes.length,
    );
  }
}
