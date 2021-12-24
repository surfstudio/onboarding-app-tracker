import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_colors.dart';

class DrawerContent extends StatelessWidget {
  final void Function() onTapTags;
  final void Function() onTapProfile;

  const DrawerContent({
    required this.onTapTags,
    required this.onTapProfile,
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
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      ListTile(
        title: Text(
          'Tags',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onTap: onTapTags,
      ),
      ListTile(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onTap: onTapProfile,
      ),
    ];
    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }
}
