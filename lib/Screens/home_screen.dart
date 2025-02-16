import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Constants/constant.dart';
import 'package:notes_app/Screens/note_screen.dart';
import 'package:notes_app/inforHandler/app_infor.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/services/note_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> backgroundColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF252525),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 51,
              ),
              Row(
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 43,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    decoration: BoxDecoration(
                      color: Color(0xFF3B3B3B),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await NoteService.readAllNotes(context);
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                              listNotes:
                                  Provider.of<AppInfor>(context, listen: false)
                                      .listNote),
                        );
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Color(0xFF3B3B3B)),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ExampleNote.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: 182,
                        ),
                        Image.asset("assets/images/rafiki.png"),
                        Text(
                          "Hãy tạo bản ghi chú đầu nào !",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    )
                  : SizedBox(
                      height: 22,
                    ),
              Expanded(
                child: StreamBuilder<List<NoteModel>>(
                    stream: NoteService.streamAllNotes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Có lỗi xảy ra"),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Image.asset("assets/images/rafiki.png");
                      }
                      List<NoteModel> listNotes = snapshot.data!;

                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(listNotes[index].uid.toString()),
                            background: Container(
                              decoration: BoxDecoration(color: Colors.red),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                return await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Color(0xFF252525),
                                    title: Icon(
                                      Icons.info_outline,
                                      size: 30,
                                    ),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Bạn có chắc muốn xóa chứ?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text(
                                              "Hủy",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(
                                              "Xóa",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            onDismissed: (direction) async {
                              await firebaseFirestore
                                  .collection("notes")
                                  .doc(listNotes[index].uid)
                                  .delete();
                            },
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteScreen(
                                    note: listNotes[index],
                                  ),
                                ),
                              ),
                              child: Card(
                                color: getRandomColor(),
                                child: ListTile(
                                  title: RichText(
                                    maxLines: 3,
                                    text: TextSpan(
                                        text: (listNotes[index].title ?? "") +
                                            "\n",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: listNotes[index].note,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16),
                                          ),
                                        ]),
                                  ),
                                  subtitle: Text(
                                    listNotes[index].date,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: listNotes.length,
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteScreen(),
                ));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.black,
          elevation: 10,
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<NoteModel>? listNotes;

  CustomSearchDelegate({required this.listNotes});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<NoteModel> resultsMatch = [];
    for (var data in listNotes!) {
      if (data.title.toLowerCase().contains(query.toLowerCase())) {
        resultsMatch.add(data);
      }
    }
    return ListView.builder(
      itemCount: resultsMatch.length,
      itemBuilder: (context, index) {
        var result = resultsMatch[index];
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteScreen(
                  note: resultsMatch![index],
                ),
              )),
          child: ListTile(
            title: Text(result.title),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<NoteModel> resultsMatch = [];
    for (var data in listNotes!) {
      if (data.title.toLowerCase().contains(query.toLowerCase())) {
        resultsMatch.add(data);
      }
    }
    return ListView.builder(
      itemCount: resultsMatch.length,
      itemBuilder: (context, index) {
        var result = resultsMatch[index];
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteScreen(
                  note: resultsMatch![index],
                ),
              )),
          child: ListTile(
            title: Text(result.title),
          ),
        );
      },
    );
  }
}
