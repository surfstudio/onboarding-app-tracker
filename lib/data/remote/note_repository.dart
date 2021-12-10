import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note/note.dart';

class NoteRepository implements INoteRepository {
  final _noteList = FirebaseFirestore.instance.collection('note_list');

  @override
  Stream<QuerySnapshot> get noteStream => _noteList.snapshots();

  @override
  Future<void> addNote(Note note) async {
    await _noteList.add(<String, dynamic>{
      'title': note.title,
      'tag': note.tag,
      'startTimestamp': note.startTimestamp,
      'endTimestamp': note.endTimestamp,
    });
  }

  @override
  Future<void> finishNote(int endTimestamp) async {
    final notesSnapshot = await _noteList.orderBy('startTimestamp').get();
    final lastRawNote = notesSnapshot.docs.last;
    await _noteList.doc(lastRawNote.id).update({'endTimestamp': endTimestamp});
  }

  @override
  Future<void> deleteNote(Note note) async {
    await _noteList.doc(note.id).delete();
  }

  @override
  Future<List<Note>> loadAllNotes() async {
    final notesSnapshot = await _noteList.orderBy('startTimestamp').get();
    return notesSnapshot.docs
        .map((rawNote) => Note.fromDatabase(rawNote))
        .toList();
  }

  @override
  Future<void> editNote({required String noteId, required Note newNoteData}) {
    // TODO(Bazarova): implement editNote
    throw UnimplementedError();
  }
}
