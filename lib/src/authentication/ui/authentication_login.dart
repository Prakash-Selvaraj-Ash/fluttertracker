import 'dart:convert';

import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationLogin extends StatelessWidget {
  final AuthenticationBloc _authenticationBloc;
  AuthenticationLogin(this._authenticationBloc);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = new TextEditingController();

    return Scaffold(
        appBar: AppBar(title: Text('eMTe')),
        body: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Please enter name", labelText: 'User Name'),
              ),
              RaisedButton(
                onPressed: () async {
                  UserResponse user = await _authenticationBloc.getUser(nameController.text);
                  print(json.encode(user.toJson()));
                  Navigator.pushNamedAndRemoveUntil(context, 'track', (p) => false, arguments: user);
                  // Navigate to home
                },
                child: Text('Login'),
              )
            ],
          ),
        )));
  }
}
