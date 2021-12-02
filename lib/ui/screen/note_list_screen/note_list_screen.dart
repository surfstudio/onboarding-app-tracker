import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/res/theme/app_edge_insets.dart';
import 'package:time_tracker/res/theme/app_typography.dart';
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
          'Список стран',
          style: AppTypography.screenTitle,
        ),
      ),
      body: EntityStateNotifierBuilder<Iterable<Note>>(
        listenableEntityState: wm.noteListState,
        loadingBuilder: (_, __) => const _LoadingWidget(),
        errorBuilder: (_, __, ___) => const _ErrorWidget(),
        builder: (_, notes) => _NoteList(
          notes: notes,
          nameStyle: wm.noteNameStyle,
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('loading'),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error'),
    );
  }
}

class _NoteList extends StatelessWidget {
  final Iterable<Note>? notes;
  final TextStyle nameStyle;

  const _NoteList({
    Key? key,
    required this.notes,
    required this.nameStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = this.notes;

    if (notes == null || notes.isEmpty) {
      return const _EmptyList();
    }

    return ListView.separated(
      itemBuilder: (_, index) => _NoteWidget(
        data: notes.elementAt(index),
        noteNameStyle: nameStyle,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: notes.length,
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Список пуст'),
    );
  }
}

class _NoteWidget extends StatelessWidget {
  final Note data;
  final TextStyle noteNameStyle;

  const _NoteWidget({
    Key? key,
    required this.data,
    required this.noteNameStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: AppEdgeInsets.top10hor20,
      child: Padding(
        padding: AppEdgeInsets.all20,
        child: Column(
          children: [
            Text(data.title),
          ],
        ),
      ),
    );
  }
}
