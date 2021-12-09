import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/res/app_typography.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_widget_model.dart';
import 'package:time_tracker/ui/screen/note_list_screen/widgets/note_list.dart';
import 'package:time_tracker/ui/widgets/loading/loading_error_widget.dart';
import 'package:time_tracker/ui/widgets/loading/loading_widget.dart';

/// Widget screen with list of notes.
class NoteListScreen extends ElementaryWidget<INoteListWidgetModel> {
  const NoteListScreen({
    Key? key,
    WidgetModelFactory wmFactory = noteListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(INoteListWidgetModel wm) {
    return Scaffold(
      // TODO(Zemcov): переделать на сливер (хочу сливер апп бар)
      appBar: AppBar(
        title: const Text(
          'Work log',
          style: AppTypography.screenTitle,
        ),
      ),
      body: EntityStateNotifierBuilder<List<Note>>(
        listenableEntityState: wm.noteListState,
        loadingBuilder: (_, __) => const LoadingWidget(),
        errorBuilder: (_, __, ___) => const LoadingErrorWidget(),
        builder: (_, notes) => RefreshIndicator(
          onRefresh: wm.loadAllNotes,
          child: SafeArea(
            top: false,
            child: NoteList(
              notes: notes,
              onDismissed: (index) async {
                final deletedNote = await wm.moveNoteToTrash(index);
                if (deletedNote != null) {
                  await wm.showCancelDeleteSnackBar(deletedNote);
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: wm.showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
