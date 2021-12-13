import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';

@freezed
class Tag with _$Tag {
  factory Tag({
    required String id,
    required String title,
  }) = _Tag;

  factory Tag.fromDatabase(QueryDocumentSnapshot document) {
    final rawTag = document.data() as Map<String, dynamic>?;
    return Tag(
      id: document.id,
      title: rawTag?['title'] as String,
    );
  }
}
