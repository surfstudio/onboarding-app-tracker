import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/screen/auth/auth_screen_model.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen_model.dart';

/// Model for [NoteListScreen]
class NoteListScreenModel extends ElementaryModel {
  final BehaviorSubject<User?> authChangesSubject = BehaviorSubject<User?>();
  final BehaviorSubject<QuerySnapshot> rawTagSubject =
      BehaviorSubject<QuerySnapshot>();
  final BehaviorSubject<QuerySnapshot> rawNoteSubject =
      BehaviorSubject<QuerySnapshot>();
  final INoteRepository _noteRepository;
  final AuthScreenModel _authScreenModel;
  final TagListScreenModel _tagListScreenModel;
  StreamSubscription? rawNoteStreamSubscription;
  StreamSubscription? rawTagStreamSubscription;
  StreamSubscription? updatedTagStreamSubscription;
  StreamSubscription? deletedTagStreamSubscription;
  StreamSubscription? _authChangesSubscription;

  NoteListScreenModel(
    this._noteRepository,
    this._tagListScreenModel,
    this._authScreenModel,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler) {
    _authChangesSubscription =
        _authScreenModel.authStateChanges.listen(_authChangesListener);
  }

  @override
  void dispose() {
    _authChangesSubscription?.cancel();
    _cancelAuthorizedSubscription();
    authChangesSubject.close();
    rawTagSubject.close();
    rawNoteSubject.close();
    super.dispose();
  }

  Future<List<Note>?> loadAllNotes() async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        return await _noteRepository.loadAllNotes(user.uid);
      } on Exception catch (e) {
        handleError(e);
        rethrow;
      }
    }
  }

  Future<void> addNote(Note note) async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        await _noteRepository.addNote(user.uid, note);
      } on Exception catch (e) {
        handleError(e);
        rethrow;
      }
    }
  }

  Future<void> finishNote(int endTimestamp) async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        await _noteRepository.finishNote(user.uid, endTimestamp);
      } on Exception catch (e) {
        handleError(e);
        rethrow;
      }
    }
  }

  Future<void> deleteNote(Note note) async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        await _noteRepository.deleteNote(user.uid, note);
      } on Exception catch (e) {
        handleError(e);
        rethrow;
      }
    }
  }

  Future<void> editNote({
    required String noteId,
    required Map<String, dynamic> newNoteData,
  }) async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        await _noteRepository.editNote(
          userId: user.uid,
          noteId: noteId,
          newNoteData: newNoteData,
        );
      } on Exception catch (e) {
        handleError(e);
        rethrow;
      }
    }
  }

  Future<void> _updatedTagStreamListener(
    Tag updatedTag, {
    bool shouldDeleteTag = false,
  }) async {
    final noteWithUpdatedTagId = _findNoteWithUpdatedTag(updatedTag);
    final newNoteData =
        _createNewNoteData(updatedTag, shouldDeleteTag: shouldDeleteTag);
    await editNote(noteId: noteWithUpdatedTagId, newNoteData: newNoteData);
  }

  void _authChangesListener(User? user) {
    if (user != null) {
      _createAuthorizedSubscription(user);
    } else {
      _cancelAuthorizedSubscription();
    }
    authChangesSubject.add(user);
  }

  void _rawNoteStreamListener(QuerySnapshot rawNoteList) {
    rawNoteSubject.add(rawNoteList);
  }

  void _rawTagStreamListener(QuerySnapshot rawTagList) {
    rawTagSubject.add(rawTagList);
  }

  Future<void> _deletedTagStreamListener(Tag updatedTag) async {
    await _updatedTagStreamListener(updatedTag, shouldDeleteTag: true);
  }

  String _findNoteWithUpdatedTag(Tag updatedTag) {
    final notes = rawNoteSubject.value.docs
        .map((rawNote) => Note.fromDatabase(rawNote))
        .toList();
    return notes.firstWhere((element) => element.tag?.id == updatedTag.id).id;
  }

  Map<String, dynamic> _createNewNoteData(
    Tag updatedTag, {
    required bool shouldDeleteTag,
  }) {
    if (shouldDeleteTag) {
      return <String, dynamic>{
        'tag': null,
      };
    } else {
      return <String, dynamic>{
        'title': updatedTag.title,
        'tag': updatedTag.toJson(),
      };
    }
  }

  void _createAuthorizedSubscription(User user) {
    rawNoteStreamSubscription = _noteRepository
        .createNoteStream(user.uid)
        .listen(_rawNoteStreamListener);
    rawTagStreamSubscription =
        _tagListScreenModel.rawTagSubject.listen(_rawTagStreamListener);
    updatedTagStreamSubscription = _tagListScreenModel.updatedTagStream.stream
        .listen(_updatedTagStreamListener);
    deletedTagStreamSubscription = _tagListScreenModel.deletedTagStream.stream
        .listen(_deletedTagStreamListener);
  }

  Future<void> _cancelAuthorizedSubscription() async {
    await rawNoteStreamSubscription?.cancel();
    await rawTagStreamSubscription?.cancel();
    await updatedTagStreamSubscription?.cancel();
    await deletedTagStreamSubscription?.cancel();
  }
}
