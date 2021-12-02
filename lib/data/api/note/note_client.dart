import 'package:time_tracker/data/dto/note/note_data.dart';
import 'package:time_tracker/ui/app/app_dependencies.dart';

// TODO(Zemcov): Когда будет бекенд переделай на генерацию ретрофитом
class NoteClient {
  final Dio dio;
  String? baseUrl;
  NoteClient(this.dio, {this.baseUrl});

  /// Получение списка заметок пользователя
  Future<List<NoteData>> getAll() async {
    // TODO(Zemcov): Удали await Future<void>.delayed(const Duration(seconds: 1));
    await Future<void>.delayed(const Duration(seconds: 1));
    return [
      NoteData(
        title: 'Созвон',
        dateTime: DateTime(2021, 12, 2, 9),
      ),
      NoteData(
        title: 'Прогаю',
        dateTime: DateTime(2021, 12, 2, 10),
      ),
      NoteData(
        title: 'Обед',
        dateTime: DateTime(2021, 12, 2, 13),
      ),
      NoteData(
        title: 'Прогаю',
        dateTime: DateTime(2021, 12, 2, 14),
      ),
      NoteData(
        title: 'Списываю время',
        dateTime: DateTime(2021, 12, 2, 18, 15),
      ),
    ];
  }
}
