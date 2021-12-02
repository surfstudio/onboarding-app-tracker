import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/res/theme/app_colors.dart';
import 'package:time_tracker/res/theme/app_decoration.dart';
import 'package:time_tracker/res/theme/app_edge_insets.dart';

class NoteWidget extends StatelessWidget {
  final Note data;
  final TextStyle noteNameStyle;

  const NoteWidget({
    Key? key,
    required this.data,
    required this.noteNameStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: AppColors.shadowColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: AppEdgeInsets.top10hor20,
      child: Padding(
        padding: AppEdgeInsets.all20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              data.title,
              style: noteNameStyle,
            ),
            Container(
              decoration: AppDecoration.note,
              child: Text(data.dateTime.toString()),
            )
          ],
        ),
      ),
    );
  }
}
