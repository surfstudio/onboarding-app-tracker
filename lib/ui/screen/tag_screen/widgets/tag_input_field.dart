import 'package:flutter/material.dart';

class TagInputField extends StatelessWidget {
  final void Function(String s) onChanged;

  const TagInputField({
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
    );
  }
}
