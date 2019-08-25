import 'package:firebase_database/firebase_database.dart';

class Posts {
  String _id;
  String _image;
  String _description;
  String _date;
  String _time;

  Posts(this._id, this._image, this._description, this._date, this._time);

  String get id => _id;

  String get image => _image;

  String get description => _description;

  String get date => _date;

  String get time => _time;

  Posts.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _image = snapshot.value['image'];
    _description = snapshot.value['description'];
    _date = snapshot.value['date'];
    _time = snapshot.value['time'];
  }
}