import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/common/alias/json_data_alias.dart';

class TagRepository implements ITagRepository {
  final databaseInstance = FirebaseFirestore.instance;

  @override
  StreamController<Tag> get updatedTagStream =>
      StreamController<Tag>.broadcast();

  @override
  StreamController<Tag> get deletedTagStream =>
      StreamController<Tag>.broadcast();

  @override
  Stream<List<Tag>> createTagStream(String userId) {
    final _tagList = tagCollection(userId);
    return _tagList
        .snapshots()
        .map((rawTag) => rawTag.docs.map(Tag.fromDatabase).toList());
  }

  @override
  Future<void> addTag(String userId, Tag tag) async {
    final _tagList = tagCollection(userId);
    await _tagList.add(<String, dynamic>{
      'title': tag.title,
    });
  }

  @override
  Future<void> deleteTag(String userId, Tag tagToDelete) async {
    final _tagList = tagCollection(userId);
    await _tagList.doc(tagToDelete.id).delete();
  }

  @override
  Future<List<Tag>> loadAllTags(
    String userId,
  ) async {
    final _tagList = tagCollection(userId);
    final tagsSnapshot = await _tagList.get();
    return tagsSnapshot.docs.map(Tag.fromDatabase).toList();
  }

  @override
  Future<void> updateTag(String userId, Tag editedTag) async {
    final _tagList = tagCollection(userId);
    await _tagList.doc(editedTag.id).update(
      {
        'title': editedTag.title,
      },
    );
  }

  CollectionReference<JsonData> tagCollection(String userId) {
    return databaseInstance
        .collection('users')
        .doc(userId)
        .collection('tag_list');
  }
}
