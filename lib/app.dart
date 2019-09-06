import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_home.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_login.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_signup.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/student_track/ui/map_track.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';

class App extends StatelessWidget {
  final RouteBloc routeBloc;
  final AuthenticationBloc authenticationBloc;
  final FirebaseMessaging firebaseMessaging;

  @provide
  App(this.routeBloc, this.authenticationBloc, this.firebaseMessaging)
      : super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case "home":
            return MaterialPageRoute(builder: (_) => AuthenticationHome());
          case "signup":
            return MaterialPageRoute(
                builder: (_) => AuthenticationSignUp(
                    routeBloc, authenticationBloc, firebaseMessaging));
          case "login":
            return MaterialPageRoute(
                builder: (_) => AuthenticationLogin(authenticationBloc));
          case "track":
            return MaterialPageRoute(
                builder: (_) => MapTrack(settings.arguments as UserResponse, routeBloc));
          default:
            return MaterialPageRoute(builder: (_) => AuthenticationHome());
        }
      },
      routes: {
        '/': (context) => AuthenticationHome(),
        '/home': (context) => AuthenticationHome(),
        '/signup': (context) => AuthenticationSignUp(
            routeBloc, authenticationBloc, firebaseMessaging),
        '/login': (context) => AuthenticationLogin(authenticationBloc),
        '/track': (context) => MapTrack(null, routeBloc)
      },
    );
  }
}
