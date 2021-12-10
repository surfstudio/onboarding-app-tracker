import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_edge_insets.dart';

class InputNoteDialog extends StatelessWidget {
  final void Function(String s) onChanged;
  final VoidCallback onSubmit;
  const InputNoteDialog({
    required this.onChanged,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: AppEdgeInsets.b10h20,
      title: const Text('Ввидите название задачи'),
      children: [
        TextFormField(
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onSubmit,
              child: const Text('Ввести'),
            ),
          ],
        ),
      ],
    );
  }
}
