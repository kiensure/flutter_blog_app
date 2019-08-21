import 'package:flutter/material.dart';
import 'Authentication.dart';

class HomePage extends StatefulWidget {

  HomePage({this.auth, this.onSignedOut});
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch(e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      body: Container(

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.local_car_wash),
                  iconSize: 50,
                  color: Colors.white,
                  onPressed: _logoutUser
              ),
              IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: null
              )
            ],
          ),
        ),
      ),
    );
  }
}