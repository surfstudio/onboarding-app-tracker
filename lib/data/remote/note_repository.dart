import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';
import 'package:time_tracker/ui/common/alias/json_data_alias.dart';

class NoteRepository implements INoteRepository {
  final databaseInstance = FirebaseFirestore.instance;

  @override
  Stream<List<Note>> createNoteStream(String userId) {
    final _noteList = notesCollection(userId);
    return _noteList
        .snapshots()
        .map((rawNote) => rawNote.docs.map(Note.fromDatabase).toList());
  }

  @override
  Future<void> addNote(String userId, Note note) async {
    final _noteList = notesCollection(userId);
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
    final _noteList = notesCollection(userId);
    final notesSnapshot = await _noteList.orderBy('startTimestamp').get();
    final lastRawNote = notesSnapshot.docs.last;
    await _noteList.doc(lastRawNote.id).update({'endTimestamp': endTimestamp});
  }

  @override
  Future<void> deleteNote(String userId, Note note) async {
    final _noteList = notesCollection(userId);
    await _noteList.doc(note.id).delete();
  }

  @override
  Future<List<Note>> loadAllNotes(String userId) async {
    final _noteList = notesCollection(userId);
    final notesSnapshot = await _noteList.orderBy('startTimestamp').get();
    return notesSnapshot.docs
        .map((rawNote) => Note.fromDatabase(rawNote))
        .toList();
  }

  @override
  Future<void> editNote({
    required String userId,
    required Note updatedNote,
  }) async {
    final _noteList = notesCollection(userId);
    final rawNoteData = {
      'title': updatedNote.title,
      'tag': updatedNote.tag?.toJson(),
    };
    await _noteList.doc(updatedNote.id).update(rawNoteData);
  }

  CollectionReference<JsonData> notesCollection(String userId) {
    return databaseInstance
        .collection('users')
        .doc(userId)
        .collection('note_list');
  }
}
