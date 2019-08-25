import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'UploadPhotoPage.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Posts> postsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference postRef = FirebaseDatabase.instance.reference().child("Posts");

    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var key in KEYS) {

        print("Key of KEYS: " + key);
        print("Key of snapshot: " + snap.key);

        Posts posts = new Posts(
            key,
            DATA[key]['image'],
            DATA[key]['description'],
            DATA[key]['date'],
            DATA[key]['time']
        );

        postsList.add(posts);
      }
      setState(() {
        print('Length: $postsList.length');
      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
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
        child: postsList.length == 0 ? Text("No Blog Post avaiable") : ListView.builder(
          itemCount:  postsList.length,
          itemBuilder: (context, index) {
            return Dismissible(
                key: Key(postsList[index].image),
                onDismissed: (direction) {
                  // Get element delete
                  Posts postsDelete = postsList[index];
                  print("post delete");
                  print("post delete " + postsDelete.id + " " + postsDelete.image);

                  final snackBar = SnackBar(
                    content: Text('Post dismissed!'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() {
                          DatabaseReference ref = FirebaseDatabase.instance.reference().child("Posts");
                          ref.push().set(postsDelete);
                          postsList.insert(index, postsDelete);
                        });
                        return;
                      },
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);

                  setState(() {
                    if(postsList.length >= 0) {
                      DatabaseReference ref = FirebaseDatabase.instance.reference().child("Posts");
                      ref.child(postsDelete.id).remove();
                      postsList.removeAt(index);
                    }
                  });
                },
                background: Container(
                  color: Colors.grey,
                ),
                child: PostsUI(
                  postsList[index].id,
                  postsList[index].image,
                  postsList[index].description,
                  postsList[index].date,
                  postsList[index].time
                )
            );
//            return PostsUI(
//              postsList[index].image,
//              postsList[index].description,
//              postsList[index].date,
//              postsList[index].time
//            );
          },
        ),
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
                  onPressed: _logoutUser),
              IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return new UploadPhotoPage();
                    }));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String id, String image, String description, String date, String time) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                )
              ],
            ),

            SizedBox(height: 10.0),

            Image.network(image, fit: BoxFit.cover),

            SizedBox(height: 10.0),

            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
