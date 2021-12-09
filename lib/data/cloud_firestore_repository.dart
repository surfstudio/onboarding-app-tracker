import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';

class CloudFirestoreNoteRepository implements INoteRepository {
  final _noteList = FirebaseFirestore.instance.collection('note_list');

  @override
  Future<void> addNote(Note note) async {
    await _noteList.add(note.toJson());
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final doc = await _getDocByNoteId(noteId);
    await _noteList.doc(doc.id).delete();
  }

  @override
  Future<void> editNote({
    required String noteId,
    required Note newNoteData,
  }) async {
    final docId = await _getDocPathByNoteId(noteId);
    await _noteList.doc(docId).update(newNoteData.toJson());
  }

  @override
  Future<List<Note>> loadAllNotes() async {
    final data = await _noteList.orderBy('startTimestamp').get();
    return data.docs.map((e) => Note.fromJson(e.data())).toList();
  }

  Future<String> _getDocPathByNoteId(String noteId) async {
    return (await _getDocByNoteId(noteId)).id;
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> _getDocByNoteId(
    String noteId,
  ) async {
    return (await _noteList.get())
        .docs
        .firstWhere((e) => e.data()['id'] == noteId);
  }
}
