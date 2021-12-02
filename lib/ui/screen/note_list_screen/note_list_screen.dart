import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/res/theme/app_typography.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/error_widget.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/loading_widget.dart';
import 'package:time_tracker/ui/screen/note_list_screen/components/note_list.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_widget_model.dart';

/// Widget screen with list of notes.
class NoteListScreen extends ElementaryWidget<INoteListWidgetModel> {
  const NoteListScreen({
    Key? key,
    WidgetModelFactory wmFactory = noteListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(INoteListWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Work log',
          style: AppTypography.screenTitle,
        ),
      ),
      body: EntityStateNotifierBuilder<Iterable<Note>>(
        listenableEntityState: wm.noteListState,
        loadingBuilder: (_, __) => const LoadingWidget(),
        errorBuilder: (_, __, ___) => const LoadingErrorWidget(),
        builder: (_, notes) => NoteList(
          notes: notes,
          nameStyle: wm.noteNameStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: wm.addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
