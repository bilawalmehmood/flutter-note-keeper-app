import 'package:flutter/material.dart';
import 'package:note_keper/models/note.dart';
import 'package:note_keper/screens/note_detail.dart';
import 'package:note_keper/screens/note_list.dart';
import 'package:note_keper/utils//database_helpers.dart';
import 'package:note_keper/utils/database_helpers.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

   return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: "Note Keeper",
     theme: ThemeData(
       primarySwatch: Colors.deepPurple,
     ),
     home: NoteList(),
   );
  }

}