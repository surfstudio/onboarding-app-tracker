import 'package:flutter/material.dart';
import 'package:time_tracker/ui/res/app_colors.dart';
import 'package:time_tracker/ui/res/app_edge_insets.dart';

class DurationWidget extends StatelessWidget {
  final Duration noteDuration;

  String get title => _durationToString(noteDuration);

  BoxDecoration get _decoration => const BoxDecoration(
        color: AppColors.bgGreen,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      );

  const DurationWidget({required this.noteDuration, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppEdgeInsets.v2h10,
      decoration: _decoration.copyWith(color: _configColor(context)),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

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

  /// The [_configColor] depends on the [noteDuration] value.
  Color _configColor(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    if (noteDuration.inHours > 2) {
      return isDarkMode
          ? AppColors.noteDurationDark.elementAt(2)
          : AppColors.noteDurationLight.elementAt(2);
    }
    if (noteDuration.inMinutes > 30) {
      return isDarkMode
          ? AppColors.noteDurationDark.elementAt(1)
          : AppColors.noteDurationLight.elementAt(1);
    }
    return isDarkMode
        ? AppColors.noteDurationDark.elementAt(0)
        : AppColors.noteDurationLight.elementAt(0);
  }
}
