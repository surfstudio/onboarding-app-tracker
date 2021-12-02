import 'package:flutter/material.dart';
import 'package:time_tracker/res/theme/app_colors.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';

/// App main widget.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          centerTitle: false,
          elevation: 0,
        ),
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData.dark(),
      home: const NoteListScreen(),
    );
  }
}
