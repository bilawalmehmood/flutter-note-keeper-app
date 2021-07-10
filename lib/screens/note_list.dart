import 'package:flutter/material.dart';
import 'package:note_keper/screens/note_detail.dart';
import 'dart:async';
import 'package:note_keper/models/note.dart';
import 'package:note_keper/utils/database_helpers.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return NoteListState();
  }

}
class NoteListState extends State<NoteList>{
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Note> noteList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }
    TextStyle textStyle=Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          nevigateToDetail(Note('','', 2),"Add Note");
          debugPrint("FAB presed");
        },
        child: Icon(Icons.add),
        tooltip: "Add Note",
      ),
    );
  }

  ListView getNoteListView(){
    TextStyle titleStyle=Theme.of(context).textTheme.subhead;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int postion){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[postion].priority),
              child: getPriorityIcon(this.noteList[postion].priority),
            ),
            title: Text(this.noteList[postion].title,style: titleStyle,),
            subtitle: Text(this.noteList[postion].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete,color: Colors.grey,),
              onTap: (){
                _delete(context, noteList[postion]);
              },
            ),
            onTap: (){
              nevigateToDetail(this.noteList[postion],'Edit Note');
              debugPrint("LsitTile tapped");
            },
          ),
        );
        });
  }
  // Return priority Color
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
          return Colors.red;
          break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }
  // Return priority icon
  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context,Note note) async{
    int result= await databaseHelper.deleteNote(note.id);
    _showSnakBar(context, "Note is Delete Successfully");
    updateListView();
  }

  void _showSnakBar(BuildContext context, String messege){
    final snackBar=SnackBar(content: Text(messege));
    Scaffold.of(context).showSnackBar(snackBar);
  }
  void nevigateToDetail(Note note,String title) async{
    bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(note,title);
    }));
    if(result==true){
      updateListView();
    }
  }
  void updateListView(){
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });
  }
}