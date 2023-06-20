import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  String id; 
  Edit({super.key, required this.id});

  @override
  State<Edit> createState() => _EditState();
}
  class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  
//inisialize field 
var title = TextEditingController();
var content = TextEditingController();

@override
void initState() {
  super.initState();
  //in first time, this method will be executed
  _getData();
}

//Http to get detail data 
Future _getData() async {
  try {
    final response = await http.get(Uri.parse(
        //you have to take the ip address of your computer
        //because using localhost will cause an error 
        //get detail data with id
        "http://192.168.1.7/note_app/detail.php?id= '${widget.id}"));

    // if response successful
    if (response.statusCode == 200) {
      final data= jsonDecode(response.body);

      setState(() {
        title = TextEditingController(text: data['title']);
        content = TextEditingController(text: data['content']);
      }); 
    }
  } catch (e) { 
    print(e);
  }
}
  }