// import 'dart:js';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/createNote.dart';
import 'package:notes/sqliteServices.dart';
import 'reorderList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: const Color.fromRGBO(58, 66, 86, 1.0),
      ),
      home: const MyHomePage(title: 'Note App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SqliteService _sqliteService;
  List post=[];


  @override
  void initState() {
    super.initState();
    getUsers();
  }
  Future<void> getUsers() async {
    _sqliteService= SqliteService();
    var data = await _sqliteService.getItems();
    setState(() {
      post=data;
    });

  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: const Text('Yes'),
              ),
            ],
          ),
    )) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          actions:  [
            TextButton(child: const Text('Edit',style: TextStyle(color: Colors.white),),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ReorderList(snap: post,)));
            },),
          ],
          centerTitle: true,
          title: Text(widget.title,textAlign: TextAlign.center,),
        ),
        body: Center(
          child:post.isNotEmpty? buildFutureBuilder():const Text('No Notes',style: TextStyle(color: Colors.white),),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor:const Color.fromRGBO(64, 75, 96, .9),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateNote(index: 0,snap: post,title: 'Add Note',)));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add,color: Colors.white,),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
  ListView buildFutureBuilder() {
    return ListView.builder(
      // shrinkWrap: true,
      // controller: _controller,
      itemCount: post.length,
      itemBuilder: (context, count) =>
          Card(
            key: ValueKey(post[count]['fname']),
            elevation: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),

            child: Container(
              decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: Dismissible(
                key: Key(post[count]['fname']),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            content: const Text('Are You Sure You Want To Delete?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  _sqliteService= SqliteService();
                                  var data = await _sqliteService.deleteData(post[count]['fname']);
                                  Navigator.pop(context);
                                  var data1 = await _sqliteService.getItems();
                                  setState(() {
                                    post=data1;
                                  });
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          ),
                    );
                  }else{
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            content: const Text('Are You Sure You Want To Delete?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  _sqliteService= SqliteService();
                                  var data = await _sqliteService.deleteData(post[count]['fname']);
                                  Navigator.pop(context);
                                  var data1 = await _sqliteService.getItems();
                                  setState(() {
                                    post=data1;
                                  });
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          ),
                    );
                  }
                },
                background: Container(
                  color: Colors.green,
                  child: const Align(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(Icons.delete)
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  child: const Align(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNote(snap:post,index:count, title: 'Edit Note',),));},
                  title: Text(post[count]['fname'].replaceAll(RegExp(r'[^0-9]'),''),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ),
    );
  }

}
