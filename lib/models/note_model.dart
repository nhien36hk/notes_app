import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String title;
  String note;
  String date;
  String? uid;

  NoteModel({
    required this.date,
    required this.title,
    required this.note,
    this.uid,
  });

  NoteModel.fromSnapshot(DocumentSnapshot snapshot)
    : title = snapshot['title'],
      note = snapshot['note'],
      date = snapshot['created_at'],
      uid = snapshot.id;
}
