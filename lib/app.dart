import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_home.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_login.dart';
import 'package:bus_tracker_client/src/authentication/ui/authentication_signup.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/signalr/signal_services.dart';
import 'package:bus_tracker_client/src/track/ui/driver_start_bus.dart';
import 'package:bus_tracker_client/src/track/ui/track.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';

class App extends StatelessWidget {
  final RouteBloc routeBloc;
  final AuthenticationBloc authenticationBloc;
  final FirebaseMessaging firebaseMessaging;
  final SignalrServices signalrServices;
  static UserResponse user;
  static List<RouteResponse> routeResonse;
  static String routeId;

  @provide
  App(this.routeBloc, this.authenticationBloc, this.firebaseMessaging, this.signalrServices)
      : super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'OpenSans',
          accentColor: Colors.blue,
          secondaryHeaderColor: Colors.amber,
          primarySwatch: Colors.purple,
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            subtitle:  TextStyle(fontSize: 16),
            button: TextStyle(fontSize: 16,color: Colors.white),
            headline: TextStyle(color: Colors.blue, fontSize: 40,),
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
            return MaterialPageRoute(builder: (_) => AuthenticationHome(routeBloc));
          case "driver":
            return MaterialPageRoute(builder: (_) => DriverStartBus(routeBloc));
          case "driver/track":
            return MaterialPageRoute(
                builder: (_) => BusTrack(routeId, routeBloc, signalrServices,true));
          case "user/signup":
            return MaterialPageRoute(
                builder: (_) => AuthenticationSignUp(
                    routeBloc, authenticationBloc, firebaseMessaging));
          case "user/login":
            return MaterialPageRoute(
                builder: (_) => AuthenticationLogin(authenticationBloc));
          case "user/track":
            return MaterialPageRoute(
                builder: (_) => BusTrack(user.routeId, routeBloc, signalrServices,false));
          default:
            return MaterialPageRoute(builder: (_) => AuthenticationHome(routeBloc));
        }
      },
      routes: {
        '/': (context) => AuthenticationHome(routeBloc),
        '/home': (context) => AuthenticationHome(routeBloc),
        '/driver': (context) => DriverStartBus(routeBloc),
        '/driver/track': (context) => BusTrack(routeId, routeBloc, signalrServices,true),
        '/user/signup': (context) => AuthenticationSignUp(
            routeBloc, authenticationBloc, firebaseMessaging),
        '/user/login': (context) => AuthenticationLogin(authenticationBloc),
        '/user/track': (context) => BusTrack(user.routeId, routeBloc, signalrServices,false)
      },
    );
  }
}
