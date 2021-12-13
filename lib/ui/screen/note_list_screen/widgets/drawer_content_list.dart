import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_colors.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen_widget_model.dart';

class DrawerContent extends StatelessWidget {
  final INoteListWidgetModel wm;

  const DrawerContent({required this.wm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = [
      DrawerHeader(
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Text(
          'Tracker',
          style: wm.subtitleStyle1,
        ),
      ),
      ListTile(
        title: Text(
          'Tags',
          style: wm.subtitleStyle2,
        ),
        onTap: wm.onTapTags,
      ),
    ];
    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }
}
