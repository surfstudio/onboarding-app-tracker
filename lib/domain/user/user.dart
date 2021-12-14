import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/domain/tag/tag.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  factory User({
    required String email,
    required String password,
    String? name,
    List<Note?>? notes,
    List<Tag?>? tags,
  }) = _User;
}
