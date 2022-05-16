// import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/sqliteServices.dart';
import 'main.dart';

class CreateNote extends StatefulWidget{
  const CreateNote({Key? key, required this.snap, required this.title, required this.index}):super(key: key);
  final List snap;
  final String title;
  final int index;
  @override
  State<CreateNote> createState()=> CreateNoteState();
}

class CreateNoteState extends State<CreateNote>{
  late SqliteService _sqliteService;
  // late File imageFile;
  late String fname=widget.title=='Edit Note'?'${widget.snap[widget.index]['fname']}':'';
  late String lname=widget.title=='Edit Note'?'${widget.snap[widget.index]['lname']}':'';
  // late String designation=fname=widget.title=='Update User'?'${widget.snap[widget.index]['designation']}':'';
  // late String cname=fname=widget.title=='Update User'?'${widget.snap[widget.index]['cName']}':'';
  // late String twitterid=fname=widget.title=='Update User'?'${widget.snap[widget.index]['twitterId']}':'';
  // late String Wnumber=fname=widget.title=='Update User'?'${widget.snap[widget.index]['wnumber']}':'';
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).padding;
   return Scaffold(
     backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(elevation: 0.1,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        centerTitle:true, title: Text(widget.title,textAlign: TextAlign.center,),),
     body: SingleChildScrollView(
       child: Container(
         padding: size.flipped,
         // height: height,
         // width: width,
         margin: const EdgeInsetsDirectional.only(start: 15,end: 15),
         child: Form(
           key: _key,
           child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(left: 15,top: 20,right: 15,bottom: 10),
                   child: Container(
                     decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                     child: TextFormField(
                       onChanged: (value){
                         setState(() {
                           fname=value;
                         });
                       },
                       initialValue:fname,
                       autovalidateMode: AutovalidateMode.onUserInteraction,
                       keyboardType: TextInputType.name,
                       decoration: const InputDecoration(
                         filled: true,
                         fillColor: Colors.lightGreenAccent,

                         border: OutlineInputBorder(
                             borderRadius:BorderRadius.all(Radius.circular(8.0))),
                         // label:  Text('First Name'),
                         hintText: "Enter Note Title Here...",
                       ),
                       validator: (value) {

                         if (value == null || value.isEmpty) {
                           return 'Enter Note Title';
                         }else if (!value.contains(RegExp(r'[a-z]')) ||
                             !value.contains(RegExp(r'[a-z]'))|| !value.contains(RegExp(r'[0-9]'))) {
                           return 'Title is Alphanumeric';
                         }
                         return null;
                       },
                     ),
                   ),
                 ),
                 const SizedBox(height: 10,),
                 Padding(
                   padding: const EdgeInsets.only(left: 15,top: 20,right: 15,bottom: 10),
                   child: Container(
                     decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                     child: TextFormField(
                       maxLines: 10,
                       keyboardType: TextInputType.multiline,
                       onChanged: (value){
                         setState(() {
                           lname=value;
                         });
                       },
                       initialValue: lname,
                       // maxLength: 10,
                       autovalidateMode: AutovalidateMode.onUserInteraction,
                       decoration:  const InputDecoration(
                         filled: true,
                         fillColor: Colors.lightGreenAccent,
                         border: OutlineInputBorder(
                             borderRadius:BorderRadius.all(Radius.circular(8.0))),
                         // label: Text('Last Name'),
                         hintText: "Enter Note Description...",
                       ),
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Enter Note Description';
                         }
                         return null;
                       },
                     ),
                   ),
                 ),
                 const SizedBox(height: 10,),
                 Container(
                   padding: const EdgeInsets.all(20),
                   child:Center(
                     child: ButtonTheme(
                       height: 30,
                       child: ElevatedButton(
                         style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent)),
                         child: const Text('Save',style:TextStyle(color: Colors.black),),
                         onPressed: () async {
                           if(_key.currentState!.validate()){
                                var values= {
                                  'fname': fname,
                                  'lname': lname,
                                };
                                if(widget.title=='Edit Note'){
                                  _sqliteService= SqliteService();
                                  var data = await _sqliteService.updateData(widget.snap[widget.index]['fname'],values);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyApp()));
                                  print(data);
                                }
                                else{
                                  _sqliteService= SqliteService();
                                  var data = await _sqliteService.createItem(values);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyApp()));
                                  print(data);
                                }

                               }

                             }),
                     ),)),
                         ]),
    ),),
   ),);
  }
}