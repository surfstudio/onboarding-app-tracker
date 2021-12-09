import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';

class CloudFirestoreNoteRepository implements INoteRepository {
  final _noteList = FirebaseFirestore.instance.collection('note_list');
  final _deletedNoteList =
      FirebaseFirestore.instance.collection('deleted_note_list');

  @override
  Future<void> addNote(Note note) async {
    await _noteList.add(note.toJson());
  }

  @override
  Future<void> moveNoteToTrash(String noteId) async {
    final doc = await _getDocByNoteId(noteId);
    final addFuture = _deletedNoteList.add(doc.data());
    final deleteFuture = _noteList.doc(doc.id).delete();
    //  Future жду отдельно, чтобы оба действия выполнялись асинхронно
    await addFuture;
    await deleteFuture;
  }

  @override
  Future<void> restoreNote(String noteId) async {
    final doc = await _getDocByNoteId(noteId, list: _deletedNoteList);
    final addFuture = _noteList.add(doc.data());
    final deleteFuture = _deletedNoteList.doc(doc.id).delete();
    //  Future жду отдельно, чтобы оба действия выполнялись асинхронно
    await addFuture;
    await deleteFuture;
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
    String noteId, {

    /// По умолчанию это [_noteList]
    CollectionReference<Map<String, dynamic>>? list,
  }) async {
    return (await (list ?? _noteList).get())
        .docs
        .firstWhere((e) => e.data()['id'] == noteId);
  }
}
