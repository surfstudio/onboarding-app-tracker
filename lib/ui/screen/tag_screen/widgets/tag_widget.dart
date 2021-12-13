import 'package:flutter/material.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/res/app_colors.dart';
import 'package:time_tracker/ui/res/app_edge_insets.dart';

class TagWidget extends StatelessWidget {
  final Tag tag;

  const TagWidget({required this.tag, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: AppEdgeInsets.h20,
      shadowColor: AppColors.shadowColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(tag.title),
      ),
    );
  }
}
