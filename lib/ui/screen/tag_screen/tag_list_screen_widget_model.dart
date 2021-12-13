import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen_model.dart';
import 'package:time_tracker/ui/screen/tag_screen/widgets/tag_input_field.dart';
import 'package:time_tracker/ui/screen/tag_screen/widgets/tag_list.dart';
import 'package:time_tracker/ui/widgets/dialog/input_dialog.dart';
import 'package:time_tracker/ui/widgets/empty_list/empty_list.dart';

part 'i_tag_list_widget_model.dart';

/// Factory for [TagListScreenWidgetModel]
TagListScreenWidgetModel tagListScreenWidgetModelFactory(
  BuildContext context,
) {
  final model = context.read<TagListScreenModel>();
  return TagListScreenWidgetModel(model);
}

/// Widget Model for [TagListScreen]
class TagListScreenWidgetModel
    extends WidgetModel<TagListScreen, TagListScreenModel>
    implements ITagListWidgetModel {
  late final StreamSubscription tagStreamSubscription;
  final _tagListState = EntityStateNotifier<List<Tag>>();

  @override
  ListenableState<EntityState<List<Tag>>> get tagListState => _tagListState;

  TagListScreenWidgetModel(TagListScreenModel model) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    tagStreamSubscription = model.tagStream.listen(_tagStreamListener);
  }

  @override
  void dispose() {
    tagStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Future<void> loadAllTags() async {
    final tags = await model.loadAllTags();
    _tagListState.content(tags);
  }

  @override
  Widget tagList() {
    final tags = _tagListState.value?.data;
    if (tags != null && tags.isNotEmpty) {
      return TagList(tags: tags, onDismissed: onTagDismissed);
    } else {
      return const EmptyList();
    }
  }

  @override
  Future<void> showAddTagDialog() async => showDialog<void>(
        context: context,
        builder: (context) {
          String? title;

          void onChanged(String inputText) => title = inputText;

          void onSubmit() {
            if (title != null) {
              final newTag = Tag(
                id: 'default',
                title: title!,
              );
              Navigator.pop(context);
              _addTag(newTag);
            }
          }

          return InputDialog(
            inputField: TagInputField(
              onChanged: onChanged,
            ),
            // onChanged: onChanged,
            onSubmit: onSubmit,
            title: 'Придумайте тег',
            submitButtonText: 'Подтвердить',
          );
        },
      );

  @override
  Future<void> onTagDismissed(int index) async {
    final tagToDelete = _tagListState.value?.data?.elementAt(index);
    if (tagToDelete != null) {
      await _deleteTag(tagToDelete);
    }
  }

  Future<void> _addTag(Tag newTag) async {
    _tagListState.value?.data?.add(newTag);
    _updateState(_tagListState.value?.data);
    try {
      await model.addTag(newTag);
    } on FirebaseException catch (_) {
      throw Exception('Cannot add new tag');
    }
  }

  Future<void> _deleteTag(Tag tagToDelete) async {
    _tagListState.value?.data?.remove(tagToDelete);
    _updateState(_tagListState.value?.data);
    try {
      await model.deleteTag(tagToDelete.id);
    } on FirebaseException catch (_) {
      throw Exception('Cannot delete tag');
    }
  }

  void _tagStreamListener(QuerySnapshot snapshot) {
    final tags =
        snapshot.docs.map((rawTag) => Tag.fromDatabase(rawTag)).toList();
    _tagListState.content(tags);
  }

  void _updateState(List<Tag>? newState) {
    if (newState != null) {
      _tagListState.content(newState);
    }
  }
}