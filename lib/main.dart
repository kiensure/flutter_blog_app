import 'package:flutter/material.dart';

import 'LoginRegisterPage.dart';

void main() => runApp(BlogApp());

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blog App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: LoginRegisterPage(),
    );
  }
}
