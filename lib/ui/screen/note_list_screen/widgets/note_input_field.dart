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
    return Autocomplete<Tag>(
      displayStringForOption: _displayStringForOption,
      optionsViewBuilder: (context, onSelected, Iterable<Tag> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: SizedBox(
              width: 270,
              height: options.length * 52,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(option.title),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
      optionsBuilder: (textEditingValue) {
        return tagList!.where((option) {
          return option
              .toString()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
    );
  }

  // ToDo(Bazarova): перенести во вью модель
  void onSelected(Tag tag) {
    _controller.text = tag.title;
    onChanged(_controller.text);
    onChooseTag(tag);
  }

  static String _displayStringForOption(Tag option) => option.title;
}
