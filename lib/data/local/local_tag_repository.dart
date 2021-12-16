import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class LocalTagRepository implements ITagRepository {
  @override
  // TODO(Bazarova): implement updatedTagStream
  StreamController<Tag> get updatedTagStream => throw UnimplementedError();

  @override
  // TODO(Bazarova): implement deletedTagStream
  StreamController<Tag> get deletedTagStream => throw UnimplementedError();

  @override
  // TODO(Bazarova): implement tagStream
  Stream<QuerySnapshot<Object?>> get tagStream => throw UnimplementedError();

  @override
  Future<void> addTag(String userId, Tag tag) async {}

  @override
  Future<void> deleteTag(String userId, Tag tagToDelete) async {}

  @override
  Future<List<Tag>> loadAllTags(
    String userId,
  ) async {
    return [Tag(id: 'default', title: 'My Tag')];
  }

  @override
  Future<void> updateTag(String userId, Tag tagToUpdate) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<Tag>> createTagStream(String userId) {
    // TODO(Bazarova): implement createTagStream
    throw UnimplementedError();
  }
}
