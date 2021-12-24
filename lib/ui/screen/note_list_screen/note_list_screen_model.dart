import 'dart:async';

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
  final BehaviorSubject<List<Tag>> rawTagSubject = BehaviorSubject<List<Tag>>();
  final BehaviorSubject<List<Note>> noteSubject = BehaviorSubject<List<Note>>();
  final INoteRepository _noteRepository;
  final AuthScreenModel _authScreenModel;
  final TagListScreenModel _tagListScreenModel;
  StreamSubscription? _rawNoteStreamSubscription;
  StreamSubscription? _rawTagStreamSubscription;
  StreamSubscription? _updatedTagStreamSubscription;
  StreamSubscription? _deletedTagStreamSubscription;
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
    noteSubject.close();
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
    required Note updatedNote,
  }) async {
    final user = authChangesSubject.value;
    if (user != null) {
      try {
        await _noteRepository.editNote(
          userId: user.uid,
          updatedNote: updatedNote,
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
    final noteWithUpdatedTag = _findNoteWithUpdatedTag(updatedTag);
    Note updatedNote;
    if (shouldDeleteTag) {
      updatedNote = noteWithUpdatedTag.copyWith(
        tag: null,
      );
    } else {
      updatedNote = noteWithUpdatedTag.copyWith(
        title: updatedTag.title,
        tag: updatedTag,
      );
    }
    await editNote(updatedNote: updatedNote);
  }

  void _authChangesListener(User? user) {
    if (user != null) {
      _createAuthorizedSubscription(user);
    } else {
      _cancelAuthorizedSubscription();
    }
    authChangesSubject.add(user);
  }

  void _rawNoteStreamListener(List<Note> noteList) {
    noteSubject.add(noteList);
  }

  void _rawTagStreamListener(List<Tag> tagList) {
    rawTagSubject.add(tagList);
  }

  Future<void> _deletedTagStreamListener(Tag updatedTag) async {
    await _updatedTagStreamListener(updatedTag, shouldDeleteTag: true);
  }

  Note _findNoteWithUpdatedTag(Tag updatedTag) {
    final notes = noteSubject.value;
    return notes.firstWhere((element) => element.tag?.id == updatedTag.id);
  }

  void _createAuthorizedSubscription(User user) {
    _rawNoteStreamSubscription = _noteRepository
        .createNoteStream(user.uid)
        .listen(_rawNoteStreamListener);
    _rawTagStreamSubscription =
        _tagListScreenModel.tagSubject.listen(_rawTagStreamListener);
    _updatedTagStreamSubscription = _tagListScreenModel.updatedTagStream.stream
        .listen(_updatedTagStreamListener);
    _deletedTagStreamSubscription = _tagListScreenModel.deletedTagStream.stream
        .listen(_deletedTagStreamListener);
  }

  Future<void> _cancelAuthorizedSubscription() async {
    await _rawNoteStreamSubscription?.cancel();
    await _rawTagStreamSubscription?.cancel();
    await _updatedTagStreamSubscription?.cancel();
    await _deletedTagStreamSubscription?.cancel();
  }
}
