import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/domain/tag/tag.dart';

abstract class ITagRepository {
  /// Real-time changes in tags stream
  Stream<QuerySnapshot> get tagStream;

  /// Real-time changes in tags stream
  StreamController<Tag> get updatedTagStream;

  /// Real-time changes in tags stream
  StreamController<Tag> get deletedTagStream;

  /// Return all tags
  Future<List<Tag>> loadAllTags();

  /// Add a new tag
  Future<void> addTag(Tag tag);

  /// Edit tag by id
  Future<void> updateTag(Tag updatedTag);

  /// Delete tag by id
  Future<void> deleteTag(Tag tagToDelete);
}
