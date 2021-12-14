import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/data/i_tag_repository.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/screen/auth/auth_screen_model.dart';

class TagListScreenModel extends ElementaryModel {
  final BehaviorSubject<QuerySnapshot> rawTagSubject =
      BehaviorSubject<QuerySnapshot>();
  final BehaviorSubject<User?> authChangesSubject = BehaviorSubject<User?>();
  final ITagRepository _tagRepository;
  final AuthScreenModel _authScreenModel;
  late final StreamController<Tag> _updatedTagStream;
  late final StreamController<Tag> _deletedTagStream;

  StreamController<Tag> get updatedTagStream => _updatedTagStream;

  StreamController<Tag> get deletedTagStream => _deletedTagStream;

  // Stream<QuerySnapshot<Object?>> get tagStream => _tagRepository.tagStream;

  StreamSubscription? _authChangesSubscription;
  StreamSubscription? _rawTagStreamSubscription;

  TagListScreenModel(
    this._tagRepository,
    this._authScreenModel,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler) {
    _updatedTagStream = _tagRepository.updatedTagStream;
    _deletedTagStream = _tagRepository.deletedTagStream;
    _authChangesSubscription =
        _authScreenModel.authStateChanges.listen(_authChangesListener);
  }

  @override
  void dispose() {
    rawTagSubject.close();
    authChangesSubject.close();
    _authChangesSubscription?.cancel();
    _cancelAuthorizedSubscription();
    super.dispose();
  }

  Future<List<Tag>?> loadAllTags() async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        return await _tagRepository.loadAllTags(user.uid);
      } on Exception catch (e) {
        handleError(e);
        rethrow;
      }
    }
  }

  Future<void> addTag(Tag tag) async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        await _tagRepository.addTag(user.uid, tag);
      } on Exception catch (e) {
        handleError(e);
        rethrow;
      }
    }
  }

  Future<void> deleteTag(Tag tagToDelete) async {
    final user = authChangesSubject.value;
    if (user != null) {
      _deletedTagStream.add(tagToDelete);
      await _tagRepository.deleteTag(user.uid, tagToDelete);
    }
  }

  Future<void> updateTag(Tag editedTag) async {
    final user = authChangesSubject.value;
    if (user != null) {
      _updatedTagStream.add(editedTag);
      await _tagRepository.updateTag(user.uid, editedTag);
    }
  }

  void _rawTagStreamListener(QuerySnapshot rawTagList) {
    rawTagSubject.add(rawTagList);
  }

  void _authChangesListener(User? user) {
    if (user != null) {
      _createAuthorizedSubscription(user);
    } else {
      _cancelAuthorizedSubscription();
    }
    authChangesSubject.add(user);
  }

  void _createAuthorizedSubscription(User user) {
    _rawTagStreamSubscription =
        _tagRepository.createTagStream(user.uid).listen(_rawTagStreamListener);
  }

  void _cancelAuthorizedSubscription() {
    _rawTagStreamSubscription?.cancel();
  }
}
