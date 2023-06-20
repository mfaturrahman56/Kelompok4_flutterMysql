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

Future _onUpdate(context) async {
  try {
    return await http.post(
      Uri.parse("http://192.168.1.7/note_app/update.php"),
      body: {
        "id": widget.id,
        "title": title.text, 
        "content": content.text,
      },
    ).then((value) {
      //print message after insert to database
      //you can improve this message with alert dialog
      var data = jsonDecode(value.body);
      print(data["message"]);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  } catch (e) {
    print(e);
  }
}

Future _onDelete(context) async {
  try{
    return await http.post(
      Uri.parse("http://192.168.1.7//note_app/delete.php"),
      body: {
        "id": widget.id,
      },
    ).then((value) {
      //print message after insert to database
      //you can improve this message with alert dialog
      var data = jsonDecode(value.body);
      print(data["message"]);
      //Remove all existing routes until the home.dart, then rebuild Home.
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  } catch (e) {
    print(e);
  }
}
  }