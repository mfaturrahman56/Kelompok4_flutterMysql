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
        "http://http://192.168.1.49/note_app/detail.php?id= '${widget.id}"));

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
      Uri.parse("http://192.168.1.49/note_app/update.php"),
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
      Uri.parse("http://192.168.1.49//note_app/delete.php"),
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
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Create New Note"),
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  //show dialog to confirm delete data
                  return AlertDialog(
                    content: const Text('Are you sure you want to delete this?'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Icon(Icons.cancel),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        child: const Icon(Icons.check_circle),
                        onPressed: () => _onDelete(context),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete)),
      )
    ],
  ),
  body: Form(
    key: _formKey,
    child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                    hintText: "Type Note Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Note Title is Required!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: content,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Type Note Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Note Content id Required!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  
                  if (_formKey.currentState!.validate()) {
                    _onUpdate(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}