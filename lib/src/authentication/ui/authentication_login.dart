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
import 'package:toast/toast.dart';

class AuthenticationLogin extends StatefulWidget {
  final AuthenticationBloc _authenticationBloc;

  AuthenticationLogin(this._authenticationBloc);

  @override
  _AuthenticationLoginState createState() => _AuthenticationLoginState();
}

class _AuthenticationLoginState extends State<AuthenticationLogin> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _validEmail = true;
  bool _validPassword = true;

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
              Text(
                'eMTe School',
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontFamily: 'Precious'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _usernameController,
                maxLength: 40,
                decoration: InputDecoration(
                  labelText: 'Email Id',
                  errorText: _validEmail ? null : 'Invalid Email Id',
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _validPassword ? null : 'Invalid Password',
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                onPressed: () async {
                  bool isValidEmail = true;
                  bool isValidPassword = true;
                  if (_usernameController.text.isEmpty ||
                      !validEmail(_usernameController.text)) {
                    isValidEmail = false;
                  }
                  if (_passwordController.text.isEmpty ||
                      !validPassword(_passwordController.text)) {
                    isValidPassword = false;
                  }
                  setState(() {
                    _validEmail = isValidEmail;
                    _validPassword = isValidPassword;
                  });
                  if (isValidEmail && isValidPassword) {
                    UserResponse user = await widget._authenticationBloc
                        .getUser(_usernameController.text);
                    if(user == null){
                      Toast.show("Invalid email id", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      return;
                    }
                    print(json.encode(user.toJson()));
                    App.routeId = user.routeId;
                    App.user = user;
                    print(App.routeResponse);
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'user/track', (p) => false,
                        arguments: user);
                  }
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
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  bool validPassword(String value) {
    if (value != '1234')
      return false;
    else
      return true;
  }
}
