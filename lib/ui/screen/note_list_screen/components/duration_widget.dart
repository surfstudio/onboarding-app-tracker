import 'package:flutter/material.dart';
import 'package:time_tracker/res/theme/app_colors.dart';
import 'package:time_tracker/res/theme/app_edge_insets.dart';
import 'package:time_tracker/res/theme/app_typography.dart';

class DurationWidget extends StatelessWidget {
  final Duration noteDuration;

  String get title => _durationToString(noteDuration);

  /// The [color] depends on the [noteDuration] value.
  Color get color {
    if (noteDuration.inHours > 2) {
      return AppColors.noteDuration.elementAt(2);
    }
    if (noteDuration.inMinutes > 30) {
      return AppColors.noteDuration.elementAt(1);
    }
    return AppColors.noteDuration.elementAt(0);
  }

  const DurationWidget({Key? key, required this.noteDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppEdgeInsets.v2h10,
      decoration: _decoration.copyWith(color: color),
      child: Text(
        title,
        style: AppTypography.cardStatus,
      ),
    );
  }

  BoxDecoration get _decoration => const BoxDecoration(
        color: AppColors.bgGreen,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      );

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String format(String twoDigits, String description) {
      if (twoDigits == '00') {
        return '';
      }
      return '$twoDigits $description';
    }

    final hours = format(twoDigits(duration.inHours), 'час ');
    final minutes = format(twoDigits(duration.inMinutes.remainder(60)), 'мин ');
    final seconds = format(twoDigits(duration.inSeconds.remainder(60)), 'сек ');
    // Проблел в return добавлен для симметрии и обусловлен наличием пробелов
    // в параметрах description метода format
    return ' $hours$minutes$seconds';
  }
}
