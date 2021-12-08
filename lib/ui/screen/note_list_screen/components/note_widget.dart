import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note.dart';
import 'package:time_tracker/res/theme/app_colors.dart';
import 'package:time_tracker/res/theme/app_decoration.dart';
import 'package:time_tracker/res/theme/app_edge_insets.dart';
import 'package:time_tracker/res/theme/app_typography.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final EdgeInsets margin;
  const NoteWidget({
    required this.note,
    Key? key,
    this.margin = AppEdgeInsets.h20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: AppColors.shadowColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: margin,
      child: Container(
        width: double.infinity,
        padding: AppEdgeInsets.all20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: AppTypography.cardTitle,
            ),
            const SizedBox(
              height: 5,
            ),
            if (note.noteDuration != null)
              Container(
                padding: AppEdgeInsets.v2h10,
                decoration: AppDecoration.note
                    .copyWith(color: note.noteDuration!.color),
                child: Text(
                  note.noteDuration!.title,
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
