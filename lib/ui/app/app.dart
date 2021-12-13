import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_colors.dart';
import 'package:time_tracker/ui/res/app_typography.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/widgets/snackbar/snack_bars.dart';

/// App main widget.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Tracker',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        textTheme: TextTheme(
          headline1: AppTypography.headline.copyWith(color: AppColors.black),
          headline2:
              AppTypography.subHeadline1.copyWith(color: AppColors.black),
          subtitle1:
              AppTypography.subHeadline1.copyWith(color: AppColors.black),
          subtitle2:
              AppTypography.subHeadline2.copyWith(color: AppColors.black),
          bodyText1: AppTypography.body.copyWith(color: AppColors.white),
          bodyText2: AppTypography.body2.copyWith(color: AppColors.black),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        textTheme: TextTheme(
          headline1: AppTypography.headline.copyWith(color: AppColors.white),
          headline2:
              AppTypography.subHeadline1.copyWith(color: AppColors.white),
          subtitle1:
              AppTypography.subHeadline1.copyWith(color: AppColors.black),
          subtitle2:
              AppTypography.subHeadline2.copyWith(color: AppColors.white),
          bodyText1: AppTypography.body.copyWith(color: AppColors.black),
          bodyText2: AppTypography.body2.copyWith(color: AppColors.white),
        ),
      ),
      home: const NoteListScreen(),
    );
  }
}
