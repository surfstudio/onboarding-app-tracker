part of 'tag_list_screen_widget_model.dart';

/// Interface of [TagListScreenWidgetModel]
abstract class ITagListWidgetModel extends IWidgetModel {
  ListenableState<EntityState<List<Tag>>> get tagListState;

  void loadAllTags();

  Widget tagList();

  Future<void> showAddTagDialog();

  Future<void> onTagDismissed(int index);

  Future<void> showEditDialog(Tag tagToEdit);
}
