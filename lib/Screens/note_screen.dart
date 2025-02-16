import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Constants/constant.dart';
import 'package:notes_app/models/note_model.dart';

class NoteScreen extends StatefulWidget {
  NoteScreen({super.key, this.note});

  NoteModel? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String? uid;
  bool isSave = false;

  saveNote() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (widget.note != null) {
      if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
        Map<String, dynamic> noteMap = {
          "title": titleController.text,
          "note": noteController.text,
          "created_at": DateTime.now().toString(),
        };
        await firebaseFirestore
            .collection("notes")
            .doc(widget.note!.uid)
            .update(noteMap);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
        if (isSave == false) {
          Map<String, dynamic> noteMap = {
            "title": titleController.text,
            "note": noteController.text,
            "created_at": DateTime.now().toString(),
          };
          DocumentReference newNoteReference =
              await firebaseFirestore.collection("notes").add(noteMap);
          uid = newNoteReference.id;
          isSave = true;
        } else {
          Map<String, dynamic> noteMap = {
            "title": titleController.text,
            "note": noteController.text,
            "created_at": DateTime.now().toString(),
          };
          await firebaseFirestore.collection("notes").doc(uid).update(noteMap);
        }
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      noteController.text = widget.note!.note;
      titleController.text = widget.note!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF252525),
          appBar: AppBar(
            backgroundColor: Color(0xFF252525),
            leading: IconButton(
              onPressed: () async {
                await saveNote();
                Navigator.pop(context);
              },
              icon: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    color: Color(0xFF3B3B3B),
                    borderRadius: BorderRadius.circular(13)),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF3B3B3B),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Color(0xFF252525),
                              title: Icon(
                                Icons.info,
                                color: Color(
                                  0xFF606060,
                                ),
                                size: 30,
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Lưu thay đổi?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 23,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 7,
                                          horizontal: 25,
                                        ),
                                        child: Text(
                                          "Bỏ đi",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await saveNote();
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 7,
                                          horizontal: 25,
                                        ),
                                        child: Text(
                                          "Lưu",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Tiêu đề",
                      hintStyle: TextStyle(
                        fontSize: 48,
                        color: Color(0xFF9A9A9A),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: noteController,
                    maxLines: null,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Nội dung",
                      hintStyle: TextStyle(
                        color: Color(0xFF9A9A9A),
                      ),
                      border: InputBorder.none,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
