import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  String id; 
  Edit({super.key, required this.id});

  @override
  State<Edit> createState();
  
}