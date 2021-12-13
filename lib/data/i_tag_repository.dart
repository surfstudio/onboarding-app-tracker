import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/domain/tag/tag.dart';

abstract class ITagRepository {
  /// Real-time changes in notes stream
  Stream<QuerySnapshot> get tagStream;

  /// Return all tags
  Future<List<Tag>> loadAllTags();

  /// Add a new tag
  Future<void> addTag(Tag tag);

  /// Edit tag by id
  Future<void> editTag(String tagId);

  /// Delete tag by id
  Future<void> deleteTag(String tagId);
}
