import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class TagListScreenModel extends ElementaryModel implements ITagRepository {
  final ITagRepository _tagRepository;
  late final StreamController<Tag> _updatedTagStream;
  late final StreamController<Tag> _deletedTagStream;

  @override
  StreamController<Tag> get updatedTagStream => _updatedTagStream;

  @override
  StreamController<Tag> get deletedTagStream => _deletedTagStream;

  @override
  Stream<QuerySnapshot<Object?>> get tagStream => _tagRepository.tagStream;

  TagListScreenModel(
    this._tagRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler) {
    _updatedTagStream = _tagRepository.updatedTagStream;
    _deletedTagStream = _tagRepository.deletedTagStream;
  }

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
  Future<void> deleteTag(Tag tagToDelete) async {
    _deletedTagStream.add(tagToDelete);
    await _tagRepository.deleteTag(tagToDelete);
  }

  @override
  Future<void> updateTag(Tag updatedTag) async {
    _updatedTagStream.add(updatedTag);
    await _tagRepository.updateTag(updatedTag);
  }
}
