import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';

class NoteRepository implements INoteRepository {
  @override
  Stream<QuerySnapshot> createNoteStream(String userId) {
    final _noteList = getFirebaseInstance(userId);
    return _noteList.snapshots();
  }

  @override
  Future<void> addNote(String userId, Note note) async {
    final _noteList = getFirebaseInstance(userId);
    final rawTag = note.tag;
    final tag = rawTag == null ? rawTag : rawTag.toJson();

    await _noteList.add(<String, dynamic>{
      'title': note.title,
      'tag': tag,
      'startTimestamp': note.startTimestamp,
      'endTimestamp': note.endTimestamp,
    });
  }

  @override
  Future<void> finishNote(String userId, int endTimestamp) async {
    final _noteList = getFirebaseInstance(userId);
    final notesSnapshot = await _noteList.orderBy('startTimestamp').get();
    final lastRawNote = notesSnapshot.docs.last;
    await _noteList.doc(lastRawNote.id).update({'endTimestamp': endTimestamp});
  }

  @override
  Future<void> deleteNote(String userId, Note note) async {
    final _noteList = getFirebaseInstance(userId);
    await _noteList.doc(note.id).delete();
  }

  @override
  Future<List<Note>> loadAllNotes(String userId) async {
    final _noteList = getFirebaseInstance(userId);
    final notesSnapshot = await _noteList.orderBy('startTimestamp').get();
    return notesSnapshot.docs
        .map((rawNote) => Note.fromDatabase(rawNote))
        .toList();
  }

  @override
  Future<void> editNote({
    required String userId,
    required String noteId,
    required Map<String, dynamic> newNoteData,
  }) async {
    final _noteList = getFirebaseInstance(userId);
    await _noteList.doc(noteId).update(newNoteData);
  }

  CollectionReference<Map<String, dynamic>> getFirebaseInstance(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('note_list');
  }
}
