import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/empty_list_widget.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/note_widget.dart';

class NoteList extends StatelessWidget {
  final List<Note>? notes;
  final void Function(int index) onDismissed;

  const NoteList({
    required this.notes,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = this.notes;

    if (notes == null || notes.isEmpty) return const EmptyListWidget();

    return ListView.builder(
      itemBuilder: (_, index) => Dismissible(
        key: ValueKey<String>(notes.elementAt(index).id),
        onDismissed: (direction) => onDismissed(index),
        child: NoteWidget(
          note: notes.elementAt(index),
        ),
      ),
      itemCount: notes.length,
    );
  }
}
