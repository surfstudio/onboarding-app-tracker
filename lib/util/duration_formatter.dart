abstract class DurationFormatter {
  static String format(Duration duration) {
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
    return ' $hours$minutes$seconds';
  }
}
