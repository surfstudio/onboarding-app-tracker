import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class TagRepository implements ITagRepository {
  final _tagList = FirebaseFirestore.instance.collection('tag_list');

  @override
  Stream<QuerySnapshot<Object?>> get tagStream => _tagList.snapshots();

  @override
  Future<void> addTag(Tag tag) async {
    await _tagList.add(<String, dynamic>{
      'title': tag.title,
    });
  }

  @override
  Future<void> deleteTag(String tagId) async {
    await _tagList.doc(tagId).delete();
  }

  @override
  Future<List<Tag>> loadAllTags() async {
    final tagsSnapshot = await _tagList.get();
    return tagsSnapshot.docs.map((rawTag) => Tag.fromDatabase(rawTag)).toList();
  }

  @override
  Future<void> editTag(String tagId) async {}
}
