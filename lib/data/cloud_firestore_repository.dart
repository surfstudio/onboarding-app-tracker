import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';

class CloudFirestoreNoteRepository implements INoteRepository {
  final _collection = FirebaseFirestore.instance.collection('note_list');

  @override
  Future<void> addNote(Note note) async {
    await _collection.add(note.toJson());
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final docId = await _getDocNameByNoteId(noteId);
    await _collection.doc(docId).delete();
  }

  @override
  Future<void> editNote({
    required String noteId,
    required Note newNoteData,
  }) async {
    final docId = await _getDocNameByNoteId(noteId);
    await _collection.doc(docId).update(newNoteData.toJson());
  }

  @override
  Future<List<Note>> loadAllNotes() async {
    final data = await _collection.orderBy('startTimestamp').get();
    return data.docs.map((e) => Note.fromJson(e.data())).toList();
  }

  Future<String> _getDocNameByNoteId(String noteId) async {
    return (await _collection.get())
        .docs
        .firstWhere((e) => e.data()['id'] == noteId)
        .id;
  }
}
