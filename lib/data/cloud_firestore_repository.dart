import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/data/i_note_repository.dart';
import 'package:time_tracker/domain/note.dart';

class CloudFirestoreNoteRepository implements INoteRepository {
  // Future<DocumentReference> addMessageToGuestBook(String message) {
  //   if (_loginState != ApplicationLoginState.loggedIn) {
  //     throw Exception('Must be logged in');
  //   }
  //
  //   return FirebaseFirestore.instance
  //       .collection('guestbook')
  //       .add(<String, dynamic>{
  //     'text': message,
  //     'timestamp': DateTime.now().millisecondsSinceEpoch,
  //     'name': FirebaseAuth.instance.currentUser!.displayName,
  //     'userId': FirebaseAuth.instance.currentUser!.uid,
  //   });
  // }

  @override
  Future<void> addNote(Note note) async {
    await FirebaseFirestore.instance.collection('noteList').add(note.toJson());
  }

  @override
  Future<void> deleteNote(String noteId) {
    // TODO: implement deleteNote
    throw UnimplementedError();
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
    // TODO: implement deleteNote
    return [];
  }
}
