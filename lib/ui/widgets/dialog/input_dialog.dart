import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_colors.dart';
import 'package:time_tracker/ui/res/app_edge_insets.dart';

class InputDialog extends StatelessWidget {
  final Widget inputField;
  final VoidCallback onSubmit;
  final String? title;
  final String? submitButtonText;

  const InputDialog({
    required this.inputField,
    required this.onSubmit,
    this.title,
    this.submitButtonText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 310),
      child: SimpleDialog(
        contentPadding: AppEdgeInsets.b10h20,
        title: Text(title ?? ''),
        children: [
          inputField,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: AppColors.black,
                ),
                onPressed: onSubmit,
                child: Text(submitButtonText ?? 'Подтвердить'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
