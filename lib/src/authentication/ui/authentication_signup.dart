import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/models/create_user.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/ui/route_place_selector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker_client/app.dart';

class AuthenticationSignUp extends StatefulWidget {
  final RouteBloc _routeBloc;
  final AuthenticationBloc _authenticationBloc;
  final FirebaseMessaging _firebaseMessaging;

  AuthenticationSignUp(
      this._routeBloc, this._authenticationBloc, this._firebaseMessaging);

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationSignUpState();
  }
}

class _AuthenticationSignUpState extends State<AuthenticationSignUp> {
  PlaceResponse _placeResponse;
  RouteResponse _routeResponse;
  String fcmToken;
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    getFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Signup')),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text('eMTe School',
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontFamily: 'Precious')),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Mobile number'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _emailController,
                decoration: InputDecoration(labelText: 'email id'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20,
              ),
              RoutePlaceSelector(widget._routeBloc, (route, place) {
                setState(() {
                  _routeResponse = route;
                  _placeResponse = place;
                });
              }, true),
              SizedBox(
                height: 70,
              ),
              RaisedButton(
                onPressed: () async {
                  UserResponse user = await widget._authenticationBloc
                      .createUser(CreateUser(
                          name: _emailController.text,
                          placeId: _placeResponse.id,
                          routeId: _routeResponse.id,
                          fcmId: fcmToken));
                  App.user = user;
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'user/track', (p) => false,
                      arguments: user);
                },
                child: Text(
                  'Register',
                  style: Theme.of(context).textTheme.button,
                ),
              )
            ],
          ),
        )));
  }

  void getFCMToken() {
    if (App.fcmToken == null) {
      widget._firebaseMessaging.getToken().then((token) {
        fcmToken = token;
      });
    } else {
      fcmToken = App.fcmToken;
    }
  }
}
