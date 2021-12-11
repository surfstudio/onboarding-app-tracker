import 'package:flutter/material.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class NoteInputField extends StatelessWidget {
  final List<Tag>? tagList;
  final Function(Tag tag) onChooseTag;
  final void Function(String s) onChanged;

  final _controller = TextEditingController();

  NoteInputField({
    required this.onChanged,
    required this.onChooseTag,
    this.tagList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: _controller,
      decoration: InputDecoration(
        suffixIcon: PopupMenuButton<Tag>(
          icon: const Icon(Icons.arrow_drop_down),
          // ToDo(Bazarova) перенести эту функцию во вью модель
          onSelected: (tag) {
            _controller.text = tag.title;
            onChanged(_controller.text);
            onChooseTag(tag);
          },
          itemBuilder: (context) {
            return tagList!.map<PopupMenuItem<Tag>>((tag) {
              return PopupMenuItem(child: Text(tag.title), value: tag);
            }).toList();
          },
        ),
      ),
    );
  }
}
