import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationHome extends StatelessWidget {
  AuthenticationHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('eMTe')),
        body: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, 'login');
                },
                child: Text('Login'),
              ),
              RaisedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, 'signup');
                },
                child: Text('Sign Up'),
              )
            ],
          ),
        )));
  }
}
