import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen_widget_model.dart';
import 'package:time_tracker/ui/screen/tag_screen/widgets/tag_list.dart';
import 'package:time_tracker/ui/widgets/empty_list/empty_list.dart';
import 'package:time_tracker/ui/widgets/loading/loading_error_widget.dart';
import 'package:time_tracker/ui/widgets/loading/loading_widget.dart';

class TagListScreen extends ElementaryWidget<ITagListWidgetModel> {
  const TagListScreen({
    Key? key,
    WidgetModelFactory wmFactory = tagListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITagListWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tags',
        ),
      ),
      body: EntityStateNotifierBuilder<List<Tag>>(
        listenableEntityState: wm.tagListState,
        loadingBuilder: (_, __) => const LoadingWidget(),
        errorBuilder: (_, __, ___) => const LoadingErrorWidget(),
        builder: (_, tags) => tags != null && tags.isNotEmpty
            ? TagList(
                tags: tags,
                onDismissed: wm.onTagDismissed,
                onTapEdit: wm.showEditDialog,
              )
            : const EmptyList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: wm.showAddTagDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
