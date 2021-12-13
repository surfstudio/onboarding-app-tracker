import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/res/app_colors.dart';
import 'package:time_tracker/ui/res/app_edge_insets.dart';
import 'package:time_tracker/ui/res/app_typography.dart';
import 'package:time_tracker/ui/screen/note_list_screen/widgets/duration_widget.dart';
import 'package:time_tracker/ui/screen/tag_screen/widgets/tag_widget.dart';

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
    final tag = note.tag;
    return Expanded(
      child: Card(
        elevation: 20,
        shadowColor: AppColors.shadowColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: margin,
        child: Container(
          padding: AppEdgeInsets.all20,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tag != null)
                    TagWidget(tag: tag)
                  else
                    Text(
                      note.title,
                      style: AppTypography.cardTitle,
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (note.isFinished)
                    DurationWidget(noteDuration: note.noteDuration)
                  else
                    const Text(
                      'в процессе...',
                      style: AppTypography.cardStatusInProgress,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
