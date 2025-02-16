import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';

class AppInfor extends ChangeNotifier{
  List<NoteModel> listNote = [];
  void addAllNotes (List<NoteModel> notes) async {
    listNote = notes;
    notifyListeners();
  }
}