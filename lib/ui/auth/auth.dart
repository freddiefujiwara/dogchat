import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dogchat/globals.dart';
import 'package:dogchat/model/dog_chat_user.dart';

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AuthState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { signIn, register }

class _AuthState extends State<Auth> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();

  String _email = "";
  String _password = "";
  FormType _form = FormType
      .signIn; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _AuthState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.signIn;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: const Text('🐕 サインイン'),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'メールアドレス'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.signIn) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('サインイン'),
              onPressed: _loginPressed,
            ),
            new FlatButton(
              child: new Text('アカウント登録されてない方はこちら'),
              onPressed: _formChange,
            ),
            new FlatButton(
              child: new Text('パスワードを忘れた方はこちら'),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('アカウントを作成'),
              onPressed: _createAccountPressed,
            ),
            new FlatButton(
              child: new Text('すでにアカウントをお持ちの方はこちら'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password

  Future<void> _loginPressed() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (userCredential != null) {
        loginUser = new DogChatUser(
            email: userCredential.user.email.toString(),
            photoUrl: userCredential.user.photoURL.toString());
        print('signInWithGoogle succeeded: $userCredential');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed('/my');
        });
      }
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("サインインできませんでした"),
            content: Text("メアド/パスワードご確認ください"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ));
    }
  }

  void _createAccountPressed() {
    print('The user wants to create an accoutn with $_email and $_password');
  }

  void _passwordReset() {
    print("The user wants a password reset request sent to $_email");
  }
}
