import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/res/app_edge_insets.dart';
import 'package:time_tracker/ui/screen/note_list_screen/widgets/note_widget.dart';
import 'package:time_tracker/ui/widgets/empty_list/empty_list.dart';

class NoteList extends StatelessWidget {
  final List<Note>? notes;
  final void Function(int index) onDismissed;
  final void Function(Note noteToEdiit) onTapEdit;
  final ScrollController? controller;

  const NoteList({
    required this.notes,
    required this.onDismissed,
    required this.onTapEdit,
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = this.notes;
    if (notes == null || notes.isEmpty) {
      return const EmptyList();
    }
    return ListView.separated(
      controller: controller,
      padding: AppEdgeInsets.v20,
      itemBuilder: (_, index) => Dismissible(
        key: ValueKey<String>(notes.elementAt(index).id),
        onDismissed: (direction) => onDismissed(index),
        background: const DismissibleBackground(),
        secondaryBackground: const DismissibleBackground(
          alignment: Alignment.centerRight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NoteWidget(
              note: notes.elementAt(index),
            ),
            IconButton(
              onPressed: () => onTapEdit(notes[index]),
              icon: const Icon(Icons.create),
            ),
          ],
        ),
      ),
      itemCount: notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
    );
  }
}

class DismissibleBackground extends StatelessWidget {
  final Alignment alignment;

  const DismissibleBackground({
    Key? key,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      color: Colors.red,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete),
      ),
    );
  }
}
