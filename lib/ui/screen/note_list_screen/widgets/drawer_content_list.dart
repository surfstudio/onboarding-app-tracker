import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_colors.dart';

class DrawerContent extends StatelessWidget {
  final void Function() onTapTags;

  const DrawerContent({
    required this.onTapTags,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = [
      DrawerHeader(
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Text(
          'Tracker',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      ListTile(
        title: Text(
          'Tags',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onTap: onTapTags,
      ),
    ];
    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }
}
