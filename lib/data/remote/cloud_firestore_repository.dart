import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';

class CloudFirestoreNoteRepository implements INoteRepository {
  final _noteList = FirebaseFirestore.instance.collection('note_list');

  @override
  Stream<QuerySnapshot> get noteStream =>
      FirebaseFirestore.instance.collection('note_list').snapshots();

  @override
  Future<void> addNote(Note note) async {
    await _noteList.add(<String, dynamic>{
      'title': note.title,
      'startTimestamp': note.startTimestamp,
      'endTimestamp': null,
    });
  }

  @override
  Future<void> finishNote(int endTimestamp) async {
    final data = await _noteList.orderBy('startTimestamp').get();
    final doc = data.docs.last;
    await _noteList.doc(doc.id).update({'endTimestamp': endTimestamp});
  }

  @override
  Future<void> deleteNote(Note note) async {
    await _noteList.doc(note.id).delete();
  }

  @override
  Future<List<Note>> loadAllNotes() async {
    final notes = <Note>[];
    final data = await _noteList.orderBy('startTimestamp').get();
    data.docs.map((doc) => Note.fromDatabase(doc)).toList();
    return notes;
  }

  @override
  Future<void> editNote({required String noteId, required Note newNoteData}) {
    // TODO: implement editNote
    throw UnimplementedError();
  }
}
