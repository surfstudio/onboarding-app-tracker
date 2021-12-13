import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class TagRepository implements ITagRepository {
  final _tagList = FirebaseFirestore.instance.collection('tag_list');

  @override
  Stream<QuerySnapshot<Object?>> get tagStream => _tagList.snapshots();

  @override
  StreamController<Tag> get updatedTagStream => StreamController<Tag>();

  @override
  StreamController<Tag> get deletedTagStream => StreamController<Tag>();

  @override
  Future<void> addTag(Tag tag) async {
    await _tagList.add(<String, dynamic>{
      'title': tag.title,
    });
  }

  @override
  Future<void> deleteTag(Tag tagToDelete) async {
    await _tagList.doc(tagToDelete.id).delete();
  }

  @override
  Future<List<Tag>> loadAllTags() async {
    final tagsSnapshot = await _tagList.get();
    return tagsSnapshot.docs.map((rawTag) => Tag.fromDatabase(rawTag)).toList();
  }

  @override
  Future<void> updateTag(Tag updatedTag) async {
    await _tagList.doc(updatedTag.id).update(
      <String, dynamic>{
        'title': updatedTag.title,
      },
    );
  }
}
