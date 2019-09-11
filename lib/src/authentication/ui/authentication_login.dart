import 'dart:convert';

import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/ui/route_place_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker_client/app.dart';

class AuthenticationLogin extends StatefulWidget {
/*  final AuthenticationBloc _authenticationBloc;
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
                  Navigator.pushNamedAndRemoveUntil(context, 'user/track', (p) => false, arguments: user);
                  // Navigate to home
                },
                child: Text('Login'),
              )
            ],
          ),
        )));
  }*/
  final AuthenticationBloc _authenticationBloc;
  AuthenticationLogin(this._authenticationBloc);

  @override
  _AuthenticationLoginState createState() => _AuthenticationLoginState();
}

class _AuthenticationLoginState extends State<AuthenticationLogin> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text('eMTe School',style: Theme.of(context).textTheme.headline.copyWith(fontFamily: 'Precious'),),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                  onPressed: () async {
                    UserResponse user = await widget._authenticationBloc.getUser(_usernameController.text);
                    print(json.encode(user.toJson()));
                    App.routeId = user.routeId;
                    App.user = user;
                    print(App.routeResonse);
                    Navigator.pushNamedAndRemoveUntil(context, 'user/track', (p) => false, arguments: user);
                    // Navigate to home
                  },
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/user/signup');
                },
                color: Theme.of(context).secondaryHeaderColor,
                child: Text(
                  'Signup',
                  style: Theme.of(context).textTheme.button.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
