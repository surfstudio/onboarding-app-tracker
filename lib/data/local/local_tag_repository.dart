import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class LocalTagRepository implements ITagRepository {
  @override
  // TODO: implement tagStream
  Stream<QuerySnapshot<Object?>> get tagStream => throw UnimplementedError();

  @override
  Future<void> addTag(Tag tag) async {}

  @override
  Future<void> deleteTag(Tag tagToDelete) async {}

  @override
  Future<List<Tag>> loadAllTags() async {
    return [Tag(id: 'default', title: 'My Tag')];
  }

  @override
  Future<void> updateTag(Tag tagToUpdate) async {
    throw UnimplementedError();
  }

  @override
  // TODO: implement updatedTagStream
  StreamController<Tag> get updatedTagStream => throw UnimplementedError();

  @override
  // TODO: implement deletedTagStream
  StreamController<Tag> get deletedTagStream => throw UnimplementedError();
}
