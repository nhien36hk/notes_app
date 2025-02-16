import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Constants/constant.dart';
import 'package:notes_app/inforHandler/app_infor.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:provider/provider.dart';

class NoteService {
  static Stream<List<NoteModel>> streamAllNotes() {
    return firebaseFirestore
        .collection("notes")
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => NoteModel.fromSnapshot(doc))
          .toList();
    });
  }

  static Future<void> readAllNotes(BuildContext context) async {
    QuerySnapshot querySnapshot = await firebaseFirestore.collection("notes").get();
    List<NoteModel> allNote = querySnapshot.docs.map((doc){
      return NoteModel.fromSnapshot(doc);
    }).toList();
    Provider.of<AppInfor>(context, listen: false).addAllNotes(allNote);
  }
}
