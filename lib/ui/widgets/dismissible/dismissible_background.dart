import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_colors.dart';

class DismissibleBackground extends StatelessWidget {
  final Alignment alignment;

  const DismissibleBackground({
    Key? key,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      color: AppColors.accentRed,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete),
      ),
    );
  }
}
