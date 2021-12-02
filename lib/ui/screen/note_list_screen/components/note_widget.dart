import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/res/theme/app_colors.dart';
import 'package:time_tracker/res/theme/app_decoration.dart';
import 'package:time_tracker/res/theme/app_edge_insets.dart';
import 'package:time_tracker/res/theme/app_typography.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final TextStyle noteNameStyle;

  const NoteWidget({
    Key? key,
    required this.note,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: noteNameStyle,
            ),
            const SizedBox(height: 5),
            if (note.eventDuration != null)
              Container(
                padding: AppEdgeInsets.ver2hor10,
                decoration:
                    AppDecoration.note.copyWith(color: note.statusColor),
                child: Text(
                  note.eventDuration!,
                  style: AppTypography.cardStatus,
                ),
              )
            else
              const Text(
                'в процессе...',
                style: AppTypography.cardStatusInProgress,
              ),
          ],
        ),
      ),
    );
  }
}
