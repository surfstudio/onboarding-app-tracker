import 'package:flutter/material.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/screen/note_list_screen/widgets/note_list.dart';
import 'package:time_tracker/ui/screen/tag_screen/widgets/tag_widget.dart';

class TagList extends StatelessWidget {
  final List<Tag> tags;
  final void Function(int index) onDismissed;
  final ScrollController? controller;

  const TagList({
    required this.tags,
    required this.onDismissed,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget itemBuilder(BuildContext context, int index) => Dismissible(
          key: ValueKey<String>(tags.elementAt(index).id),
          onDismissed: (direction) => onDismissed(index),
          background: const DismissibleBackground(),
          secondaryBackground: const DismissibleBackground(
            alignment: Alignment.centerRight,
          ),
          child: TagWidget(
            tag: tags.elementAt(index),
          ),
        );
    Widget separatorBuilder(BuildContext context, int i) => const Divider();
    final itemCount = tags.length;
    return ListView.separated(
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      itemCount: itemCount,
    );
  }
}
