import 'dart:collection';
import 'dart:convert';

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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inject/inject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  final RouteBloc routeBloc;
  final TrackBloc trackBloc;
  final Future<SharedPreferences> _pref;
  static SharedPreferences sharedPref;
  final AuthenticationBloc authenticationBloc;
  final FirebaseMessaging _firebaseMessaging;
  final SignalrServices signalrServices;
  static final HashMap<String, String> BUS_IDS = HashMap();

  static UserResponse get user {
    String jsonString = sharedPref?.getString('user');
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> map = json.decode(jsonString);
      if (map == null || map.isEmpty) {
        return null;
      } else {
        return UserResponse.fromJson(map);
      }
    }
  }

  static List<RouteResponse> get routeResponse {
    String jsonString = sharedPref?.getString('routeResonse');
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    } else {
      List<dynamic> routes = json.decode(jsonString);
      if (routes == null) {
        return null;
      } else {
        return routes.map((route) => RouteResponse.fromJson(route)).toList();
      }
    }
  }

  static String get routeId {
    return sharedPref?.getString('routeId');
  }

  static String get selectedBusId {
    return sharedPref?.getString('selectedBusId');
  }

  static String get fcmToken {
    return sharedPref?.getString('fcmToken');
  }

  static void set fcmToken(String value) {
    sharedPref?.setString('fcmToken', value);
  }

  static void set selectedBusId(String value) {
    sharedPref?.setString('selectedBusId', value);
  }

  static void set routeId(String value) {
    sharedPref?.setString('routeId', value);
  }

  static void saveRouteResonse(String value) {
    sharedPref?.setString('routeResonse', value);
  }

  static void set user(UserResponse value) {
    sharedPref?.setString('user', json.encode(value));
  }

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token;
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        print(message['notification']);
        print(message['notification']['title']);
        print(message['notification']['body']);

        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        var initializationSettingsAndroid =
            new AndroidInitializationSettings('ic_launcher');
        var onDidReceiveLocalNotification;
        var initializationSettingsIOS = new IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
        var initializationSettings = new InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);
        flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onSelectNotification: _onSelectNotification);

        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'notification_channel', 'notification_channel_name', 'test',
            importance: Importance.Max,
            priority: Priority.High,
            ticker: 'ticker');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            message['notification']['title'],
            message['notification']['body'],
            platformChannelSpecifics,
            payload: 'item x');

        navigatorKey.currentState.pushNamedAndRemoveUntil(
          '/user/track',
          (p) => false,
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print('on message $message');
        print(message['notification']);
        print(message['notification']['title']);
        print(message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on message $message');
        print(message['notification']);
        print(message['notification']['title']);
        print(message['notification']['body']);
      },
    );
  }

  Future _onSelectNotification(String payload) async {
    print('on payload $payload');
    navigatorKey.currentState.pushNamedAndRemoveUntil(
      '/user/track',
      (p) => false,
    );
  }

  void handlingNotification(Map<String, String> message) {
    print('on message $message');
    print(message['title']);
    print(message['body']);
  }

  @provide
  App(this.routeBloc, this.trackBloc, this.authenticationBloc,
      this._firebaseMessaging, this.signalrServices, this._pref)
      : super();

  @override
  Widget build(BuildContext context) {
    initPreferences();
    initHashMap();
    firebaseCloudMessagingListeners();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
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
                    routeBloc, authenticationBloc, _firebaseMessaging));
          case "user/login":
            return MaterialPageRoute(
                builder: (_) => AuthenticationLogin(authenticationBloc));
          case "user/track":
            return MaterialPageRoute(
                builder: (_) => BusTrack(
                    routeId, routeBloc, trackBloc, signalrServices, false));
          default:
            return MaterialPageRoute(
                builder: (_) => AuthenticationHome(routeBloc));
        }
      },
      routes: {
        '/': (context) => user != null
            ? BusTrack(routeId, routeBloc, trackBloc, signalrServices, false)
            : routeId != null
                ? BusTrack(routeId, routeBloc, trackBloc, signalrServices, true)
                : AuthenticationHome(routeBloc),
        '/home': (context) => AuthenticationHome(routeBloc),
        '/driver': (context) => DriverStartBus(routeBloc),
        '/driver/track': (context) =>
            BusTrack(routeId, routeBloc, trackBloc, signalrServices, true),
        '/user/signup': (context) => AuthenticationSignUp(
            routeBloc, authenticationBloc, _firebaseMessaging),
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

  void initPreferences() async {
//    sharedPref = await _pref;
  }

  static void clearPref() {
    print('preferrence cleared');
    App.saveRouteResonse(null);
    App.user = null;
    App.routeId = null;
    App.selectedBusId = null;
  }
}
