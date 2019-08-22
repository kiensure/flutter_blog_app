import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {

  final AuthImplementaion auth;
  final VoidCallback onSignedIn;

  LoginRegisterPage({
    this.auth,
    this.onSignedIn
  });

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();

}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  DialogBox dialogBox = new DialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
  bool _obscureText = true;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if(validateAndSave()){
      try {
        if(_formType == FormType.login){
          String userId = await widget.auth.signIn(_email, _password);
          //dialogBox.infomation(context, "Congratulations", "Your are logged in successfully.");
          print("login: $userId");
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          //dialogBox.infomation(context, "Congratulations", "Your account has been create successfully.");
          print("signup: $userId");
        }
        widget.onSignedIn();
      } catch(e) {
        dialogBox.infomation(context, "Error", e.toString());
        print(e);
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(centerTitle: true, title: Text("Flutter Blog App")),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(height: 10.0),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: "Email"),
        validator: (value) {
          return value.isEmpty ? 'Email is required.' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(height: 10.0),
      Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          new TextFormField(
            decoration: new InputDecoration(labelText: "Password"),
            obscureText: _obscureText,
            validator: (value) {
              return value.isEmpty ? 'Password is required.' : null;
            },
            onSaved: (value) {
              return _password = value;
            },
          ),
          IconButton(
              icon: new Icon(Icons.remove_red_eye),
              onPressed: _toggle,
              color: _obscureText ? Colors.red : Colors.grey,
          )
        ],
      ),
      SizedBox(height: 20.0)
    ];
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
            onPressed: validateAndSubmit,
            child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
            textColor: Colors.white,
            color: Colors.pink),
        new FlatButton(
            onPressed: moveToRegister,
            child: new Text("Not have an Account? Create Account?",
                style: new TextStyle(fontSize: 14)),
            textColor: Colors.red)
      ];
    } else {
      return [
        new RaisedButton(
            onPressed: validateAndSubmit,
            child: new Text("Create Account",
                style: new TextStyle(fontSize: 20.0)),
            textColor: Colors.white,
            color: Colors.pink
        ),
        new FlatButton(
            onPressed: moveToLogin,
            child: new Text("Already have an Account? Login",
                style: new TextStyle(fontSize: 14)),
            textColor: Colors.red
        )
      ];
    }
  }

  Widget logo() {
    return new Hero(
      tag: "hero",
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset("images/app_logo.png")
      )
    );
  }
}
