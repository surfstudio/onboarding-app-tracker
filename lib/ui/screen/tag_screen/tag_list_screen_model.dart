import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class TagListScreenModel extends ElementaryModel implements ITagRepository {
  final ITagRepository _tagRepository;

  @override
  Stream<QuerySnapshot<Object?>> get tagStream => _tagRepository.tagStream;

  TagListScreenModel(
    this._tagRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  Future<List<Tag>> loadAllTags() async {
    try {
      return await _tagRepository.loadAllTags();
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
  Future<void> addTag(Tag tag) async {
    try {
      await _tagRepository.addTag(tag);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteTag(String tagId) async {
    await _tagRepository.deleteTag(tagId);
  }

  @override
  Future<void> editTag(String tagId) async {}
}
