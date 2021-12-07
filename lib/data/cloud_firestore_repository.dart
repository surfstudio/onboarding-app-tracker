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
    final doc = (await _collection.get())
        .docs
        .firstWhere((e) => e.data()['id'] == noteId);
    await _collection.doc(doc.id).delete();
  }

  @override
  Future<void> editNote({
    required String noteId,
    required Note newNoteData,
  }) {
    // TODO: implement editNote
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> loadAllNotes() async {
    final data = await _collection.orderBy('startTimestamp').get();
    return data.docs.map((e) => Note.fromJson(e.data())).toList();
  }
}
