import 'package:bus_tracker_client/src/authentication/blocs/authentication_bloc.dart';
import 'package:bus_tracker_client/src/authentication/blocs/authentication_provider.dart';
import 'package:bus_tracker_client/src/authentication/resources/authentication_repository.dart';
import 'package:bus_tracker_client/src/authentication/webclient/authentication_client.dart';
import 'package:bus_tracker_client/src/blocs/bloc_base.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/blocs/route_provider.dart';
import 'package:bus_tracker_client/src/route/resources/route_repository.dart';
import 'package:bus_tracker_client/src/route/webclient/route_client.dart';
import 'package:bus_tracker_client/src/signalr/signal_services.dart';
import 'package:bus_tracker_client/src/track/blocs/track_bloc.dart';
import 'package:bus_tracker_client/src/track/blocs/track_provider.dart';
import 'package:bus_tracker_client/src/track/resources/track_repository.dart';
import 'package:bus_tracker_client/src/track/webclient/track_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inject/inject.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

@module
class AppModule {
  
  @provide
  FirebaseMessaging firebaseMessaging() => FirebaseMessaging();
  
  @provide
  @singleton
  Client client() => Client();

  @provide
  @singleton
  RouteClient routeClient() => RouteClient(client());

  @provide
  @singleton
  RouteProvider routeProvider() => RouteProvider(routeClient());

  @provide
  @singleton
  RouteRepository routeRepository() => RouteRepository(routeProvider());

  @provide
  BlocBase routeBloc() => RouteBloc(routeRepository());

  @provide
  @singleton
  AuthenticationClient authenticationClient() => AuthenticationClient(client());

  @provide
  @singleton
  AuthenticationProvider authenticationProvider() => AuthenticationProvider(authenticationClient());

  @provide
  @singleton
  AuthenticationRepository authenticationRepository() => AuthenticationRepository(authenticationProvider());

  @provide
  BlocBase authenticationBloc() => AuthenticationBloc(authenticationRepository());

  @provide
  SignalrServices signalRService() => SignalrServices();

  @provide
  @singleton
  TrackClient trackClient() => TrackClient(client());

  @provide
  @singleton
  TrackProvider trackProvider() => TrackProvider(trackClient());

  @provide
  @singleton
  TrackRepository trackRepository() => TrackRepository(trackProvider());

  @provide
  BlocBase trackBloc() => TrackBloc(trackRepository());

  @provide
  @singleton
  Future<SharedPreferences> sharedPreferences() async => await SharedPreferences.getInstance();

}
