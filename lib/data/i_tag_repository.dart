import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/domain/tag/tag.dart';

abstract class ITagRepository {
  /// Real-time changes in tags stream
  StreamController<Tag> get updatedTagStream;

  /// Real-time changes in tags stream
  StreamController<Tag> get deletedTagStream;

  /// Real-time changes in tags stream
  Stream<QuerySnapshot> createTagStream(String userId);

  /// Return all tags
  Future<List<Tag>> loadAllTags(String userId);

  /// Add a new tag
  Future<void> addTag(String userId, Tag tag);

  /// Edit tag by id
  Future<void> updateTag(String userId, Tag updatedTag);

  /// Delete tag by id
  Future<void> deleteTag(String userId, Tag tagToDelete);
}
