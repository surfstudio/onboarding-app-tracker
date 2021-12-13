import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elementary/elementary.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/domain/tag/tag.dart';
import 'package:time_tracker/ui/screen/note_list_screen/note_list_screen.dart';
import 'package:time_tracker/ui/screen/tag_screen/tag_list_screen_model.dart';

/// Model for [NoteListScreen]
class NoteListScreenModel extends ElementaryModel {
  final TagListScreenModel tagListScreenModel;
  final BehaviorSubject<QuerySnapshot> rawTagSubject =
      BehaviorSubject<QuerySnapshot>();
  late final BehaviorSubject<QuerySnapshot> rawNoteSubject;
  late final StreamSubscription _rawNoteStreamSubscription;
  late final StreamSubscription _rawTagStreamSubscription;
  late final StreamSubscription _updatedTagStreamSubscription;
  late final StreamSubscription _deletedTagStreamSubscription;
  final INoteRepository _noteRepository;

  NoteListScreenModel(
    this._noteRepository,
    this.tagListScreenModel,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler) {
    _rawNoteStreamSubscription =
        _noteRepository.noteStream.listen(_rawNoteStreamListener);
    _rawTagStreamSubscription =
        tagListScreenModel.tagStream.listen(_rawTagStreamListener);
    _updatedTagStreamSubscription = tagListScreenModel.updatedTagStream.stream
        .listen(_updatedTagStreamListener);
    _deletedTagStreamSubscription = tagListScreenModel.deletedTagStream.stream
        .listen(_deletedTagStreamListener);
    rawNoteSubject = BehaviorSubject<QuerySnapshot>();
  }

  @override
  void dispose() {
    _rawNoteStreamSubscription.cancel();
    _rawTagStreamSubscription.cancel();
    _updatedTagStreamSubscription.cancel();
    _deletedTagStreamSubscription.cancel();
    rawTagSubject.close();
    rawNoteSubject.close();
    super.dispose();
  }

  Future<List<Note>> loadAllNotes() async {
    try {
      return await _noteRepository.loadAllNotes();
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _noteRepository.addNote(note);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> finishNote(int endTimestamp) async {
    try {
      await _noteRepository.finishNote(endTimestamp);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _noteRepository.deleteNote(note);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> editNote({
    required String noteId,
    required Map<String, dynamic> newNoteData,
  }) async {
    try {
      await _noteRepository.editNote(
        noteId: noteId,
        newNoteData: newNoteData,
      );
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  void _rawNoteStreamListener(QuerySnapshot rawNoteList) {
    rawNoteSubject.add(rawNoteList);
  }

  void _rawTagStreamListener(QuerySnapshot rawTagList) {
    rawTagSubject.add(rawTagList);
  }

  Future<void> _updatedTagStreamListener(
    Tag updatedTag, {
    bool shouldDeleteTag = false,
  }) async {
    final notes = rawNoteSubject.value.docs
        .map((rawNote) => Note.fromDatabase(rawNote))
        .toList();
    final noteWithUpdatedTagId =
        notes.firstWhere((element) => element.tag?.id == updatedTag.id).id;
    Map<String, dynamic> newNoteData;

    if (shouldDeleteTag) {
      newNoteData = <String, dynamic>{
        'tag': null,
      };
    } else {
      newNoteData = <String, dynamic>{
        'title': updatedTag.title,
        'tag': <String, dynamic>{
          'title': updatedTag.title,
          'id': updatedTag.id,
        },
      };
    }
    await editNote(noteId: noteWithUpdatedTagId, newNoteData: newNoteData);
  }

  Future<void> _deletedTagStreamListener(Tag updatedTag) async {
    await _updatedTagStreamListener(updatedTag, shouldDeleteTag: true);
  }
}
