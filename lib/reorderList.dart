import 'package:flutter/material.dart';
import 'package:notes/sqliteServices.dart';

import 'createNote.dart';
import 'main.dart';
class ReorderList extends StatefulWidget{
  const ReorderList({Key? key, required this.snap,}):super(key: key);
  final List snap;

  @override
  ReorderListState createState(){
    return ReorderListState();
  }
}
class ReorderListState extends State<ReorderList>{
  late SqliteService _sqliteService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        actions:  [
          TextButton(child: const Text('Done',style: TextStyle(color: Colors.white),),
            onPressed: (){
            _sqliteService = SqliteService();
            _sqliteService.delete();
            for(int i=0;i<widget.snap.length;i++){
              var value= {
              'fname': widget.snap[i]['fname'],
              'lname': widget.snap[i]['lname']
            };
              _sqliteService.createItem(value);
            }
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyApp()));
          },),
        ],
        centerTitle: true,
        title: const Text('List Items',textAlign: TextAlign.center,),
      ),
      body: Center(
        child:widget.snap.isNotEmpty? buildFutureBuilder1():const Text('No Notes',style: TextStyle(color: Colors.white),),
      ),
    );
  }

  ReorderableListView buildFutureBuilder1() {
    return ReorderableListView.builder(
      // shrinkWrap: true,
      // controller: _controller,
      itemCount: widget.snap.length,
      itemBuilder: (context, count) =>
          Card(
            key: ValueKey(widget.snap[count]['fname']),
            elevation: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
            child: Container(
              decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                trailing: const Icon(Icons.drag_handle,color: Colors.white,),
                // onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUserScreen2(snap:widget.snap,index:count, title: 'Edit Note',),));},
                title: Text(widget.snap[count]['fname'].replaceAll(RegExp(r'[^0-9]'),''),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          )), onReorder: (int oldIndex, int newIndex) {
      setState(() {
        if (newIndex > oldIndex) {
          newIndex = newIndex - 1;
        }
        final element = widget.snap.removeAt(oldIndex);
        widget.snap.insert(newIndex, element);
      });
    },
    );
  }
}