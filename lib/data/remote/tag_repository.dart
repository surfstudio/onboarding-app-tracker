import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class TagRepository implements ITagRepository {
  @override
  StreamController<Tag> get updatedTagStream =>
      StreamController<Tag>.broadcast();

  @override
  StreamController<Tag> get deletedTagStream =>
      StreamController<Tag>.broadcast();

  @override
  Stream<QuerySnapshot> createTagStream(String userId) {
    final _tagList = getFirebaseInstance(userId);
    return _tagList.snapshots();
  }

  @override
  Future<void> addTag(String userId, Tag tag) async {
    final _tagList = getFirebaseInstance(userId);
    await _tagList.add(<String, dynamic>{
      'title': tag.title,
    });
  }

  @override
  Future<void> deleteTag(String userId, Tag tagToDelete) async {
    final _tagList = getFirebaseInstance(userId);
    await _tagList.doc(tagToDelete.id).delete();
  }

  @override
  Future<List<Tag>> loadAllTags(
    String userId,
  ) async {
    final _tagList = getFirebaseInstance(userId);
    final tagsSnapshot = await _tagList.get();
    return tagsSnapshot.docs.map((rawTag) => Tag.fromDatabase(rawTag)).toList();
  }

  @override
  Future<void> updateTag(String userId, Tag editedTag) async {
    final _tagList = getFirebaseInstance(userId);
    await _tagList.doc(editedTag.id).update(
      <String, dynamic>{
        'title': editedTag.title,
      },
    );
  }

  CollectionReference<Map<String, dynamic>> getFirebaseInstance(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tag_list');
  }
}
