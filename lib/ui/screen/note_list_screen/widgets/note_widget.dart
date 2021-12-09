import 'package:flutter/material.dart';
import 'package:time_tracker/domain/note.dart';
import 'package:time_tracker/ui/res/app_colors.dart';
import 'package:time_tracker/ui/res/app_edge_insets.dart';
import 'package:time_tracker/ui/res/app_typography.dart';
import 'package:time_tracker/ui/screen/note_list_screen/widgets/duration_widget.dart';

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
              DurationWidget(noteDuration: note.noteDuration!)
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
//
// class SinceFromWidget extends StatelessWidget {
//   final DateTime startDateTime;
//   const SinceFromWidget({
//     Key? key, requared this.startDateTime,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       (note.startDateTime?.millisecondsSinceEpoch).toString(),
//       style: AppTypography.cardStatusInProgress,
//     );
//   }
// }
