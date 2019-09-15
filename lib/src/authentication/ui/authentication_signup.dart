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
import 'package:toast/toast.dart';

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

  bool _validEmail = true;
  bool _validMobile = true;
  bool _validName = true;

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
                decoration: InputDecoration(
                    labelText: 'Name',
                    errorText: _validName
                        ? null
                        : 'Name must be more than 2 charater'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: 'Mobile number',
                    errorText: _validMobile
                        ? null
                        : 'Mobile Number must be of 10 digit'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: Theme.of(context).textTheme.subtitle,
                autofocus: false,
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'email id',
                    errorText: _validEmail ? null : 'Invalid Email Id'),
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
                  bool isValidEmail = true;
                  bool isValidPhone = true;
                  bool isValidName = true;
                  if (_nameController.text.isEmpty ||
                      !validateName(_nameController.text)) {
                    isValidName = false;
                  }
                  if (_phoneController.text.isEmpty ||
                      !validateMobile(_phoneController.text)) {
                    isValidPhone = false;
                  }
                  if (_emailController.text.isEmpty ||
                      !validateEmail(_emailController.text)) {
                    isValidEmail = false;
                  }
                  setState(() {
                    _validName = isValidName;
                    _validMobile = isValidPhone;
                    _validEmail = isValidEmail;
                  });
                  if (isValidEmail && isValidPhone && isValidName) {
                    if (_placeResponse == null || _routeResponse == null) {
                      Toast.show("Please select your route and place", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      return;
                    }
                    try {
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
                    } on Exception {
                      Toast.show("please check your network connection", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      return;
                    }
                  }
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

  bool validateName(String value) {
    if (value.length < 3)
      return false;
    else
      return true;
  }

  bool validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return false;
    else
      return true;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
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
