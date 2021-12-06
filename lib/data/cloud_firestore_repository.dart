import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';

class CloudFirestoreNoteRepository implements INoteRepository {
  final _collectionName = 'note_list';
  final _fireInstance = FirebaseFirestore.instance;

  @override
  Future<void> addNote(Note note) async {
    await _fireInstance.collection(_collectionName).add(note.toJson());
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final collection = _fireInstance.collection(_collectionName);
    debugPrint(collection.toString());
    // await _fireInstance
    //     .collection(_collectionName)
    //     .doc()
    //     .update({'noteId': 'null'});
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
    final result = <Note>[];
    await _fireInstance
        .collection(_collectionName)
        .doc()
        .snapshots()
        .forEach((document) {
      final data = document.data();
      if (data == null) return;
      result.add(
        Note(
          id: data['id'].toString(),
          title: data['title'].toString(),
          startDateTime: DateTime.now(),
          //TODO
        ),
      );
    });

    return result;
  }
}
