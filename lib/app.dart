import 'dart:collection';

import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_home.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_login.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_signup.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/signalr/signal_services.dart';
import 'package:bus_tracker_client/src/track/blocs/track_bloc.dart';
import 'package:bus_tracker_client/src/track/ui/driver_start_bus.dart';
import 'package:bus_tracker_client/src/track/ui/track.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';

class App extends StatelessWidget {
  final RouteBloc routeBloc;
  final TrackBloc trackBloc;
  final AuthenticationBloc authenticationBloc;
  final FirebaseMessaging firebaseMessaging;
  final SignalrServices signalrServices;
  static UserResponse user;
  static List<RouteResponse> routeResonse;
  static String routeId;
  static final HashMap<String, String> BUS_IDS = HashMap();
  static String selectedBusId;

  @provide
  App(this.routeBloc, this.trackBloc, this.authenticationBloc,
      this.firebaseMessaging, this.signalrServices)
      : super();

  @override
  Widget build(BuildContext context) {
    initHashMap();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'OpenSans',
          accentColor: Colors.blue,
          secondaryHeaderColor: Colors.amber,
          primarySwatch: Colors.purple,
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                subtitle: TextStyle(fontSize: 16),
                button: TextStyle(fontSize: 16, color: Colors.white),
                headline: TextStyle(
                  color: Colors.blue,
                  fontSize: 35,
                ),
              ),
          buttonTheme: ThemeData.light().buttonTheme.copyWith(
                buttonColor: Colors.blue,
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(fontFamily: 'Quicksand', fontSize: 20)))),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case "home":
            return MaterialPageRoute(
                builder: (_) => AuthenticationHome(routeBloc));
          case "driver":
            return MaterialPageRoute(builder: (_) => DriverStartBus(routeBloc));
          case "driver/track":
            return MaterialPageRoute(
                builder: (_) => BusTrack(
                    routeId, routeBloc, trackBloc, signalrServices, true));
          case "user/signup":
            return MaterialPageRoute(
                builder: (_) => AuthenticationSignUp(
                    routeBloc, authenticationBloc, firebaseMessaging));
          case "user/login":
            return MaterialPageRoute(
                builder: (_) => AuthenticationLogin(authenticationBloc));
          case "user/track":
            return MaterialPageRoute(
                builder: (_) => BusTrack(routeId, routeBloc, trackBloc,
                    signalrServices, false));
          default:
            return MaterialPageRoute(
                builder: (_) => AuthenticationHome(routeBloc));
        }
      },
      routes: {
        '/': (context) => AuthenticationHome(routeBloc),
        '/home': (context) => AuthenticationHome(routeBloc),
        '/driver': (context) => DriverStartBus(routeBloc),
        '/driver/track': (context) =>
            BusTrack(routeId, routeBloc, trackBloc, signalrServices, true),
        '/user/signup': (context) => AuthenticationSignUp(
            routeBloc, authenticationBloc, firebaseMessaging),
        '/user/login': (context) => AuthenticationLogin(authenticationBloc),
        '/user/track': (context) =>
            BusTrack(routeId, routeBloc, trackBloc, signalrServices, false)
      },
    );
  }

  void initHashMap() {
    BUS_IDS.putIfAbsent("a7a196d5-fb53-445b-a385-8e0d75e5cdd5",
        () => "adea5d3f-a898-4119-9325-a7982517b335");
    BUS_IDS.putIfAbsent("6047eb09-965a-4a61-9bbc-b8f3817024f0",
        () => "5f98a463-722f-4e7c-9d32-5fe4993926a8");
  }
}
