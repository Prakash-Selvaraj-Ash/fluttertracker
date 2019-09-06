import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/models/create_user.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/ui/route_selector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationSignUp extends StatefulWidget {
  final RouteBloc _routeBloc;
  final AuthenticationBloc _authenticationBloc;
  final FirebaseMessaging _firebaseMessaging;
  AuthenticationSignUp(
      this._routeBloc, this._authenticationBloc, this._firebaseMessaging);
  @override
  State<StatefulWidget> createState() {
    return _AuthenticationSignUpState(
        _routeBloc, _authenticationBloc, _firebaseMessaging);
  }
}

class _AuthenticationSignUpState extends State {
  final RouteBloc _routeBloc;
  final AuthenticationBloc _authenticationBloc;
  final FirebaseMessaging _firebaseMessaging;
  PlaceResponse _placeResponse;
  RouteResponse _routeResponse;
  String fcmToken;
  TextEditingController nameController = new TextEditingController();

  _AuthenticationSignUpState(
      this._routeBloc, this._authenticationBloc, this._firebaseMessaging);

  @override
  void initState() {
    firebaseCloudMessagingListeners();
    super.initState();
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token;
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('eMTe')),
        body: Scaffold(
            body: Container(
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Please enter name", labelText: 'Post Body'),
              ),
              RouteSelector(_routeBloc, (route, place) {
                setState(() {
                  _routeResponse = route;
                  _placeResponse = place;
                });
              }),
              RaisedButton(
                onPressed: () async {
                  UserResponse user = await _authenticationBloc.createUser(
                      CreateUser(
                          name: nameController.text,
                          placeId: _placeResponse.id,
                          routeId: _routeResponse.id,
                          fcmId: fcmToken));
                  //Navigate to home
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'login', (predicate) => false);
                },
                child: Text('Register'),
              )
            ],
          ),
        )));
  }
}
