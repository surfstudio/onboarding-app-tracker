import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen_widget_model.dart';

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
        loadingBuilder: (_, __) => Container(),
        errorBuilder: (_, __, ___) => Container(),
        builder: (_, tags) => wm.tagList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: wm.showAddTagDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
