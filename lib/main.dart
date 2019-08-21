import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Authentication.dart';

void main() => runApp(BlogApp());

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blog App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MappingPage(auth: Auth()),
    );
  }
}
