import 'app_injector.dart' as _i1;
import 'app_module.dart' as _i2;
import '../route/resources/route_repository.dart' as _i3;
import '../track/resources/track_repository.dart' as _i4;
import '../authentication/resources/authentication_repository.dart' as _i5;
import 'dart:async' as _i6;
import '../../app.dart' as _i7;
import '../route/blocs/route_bloc.dart' as _i8;
import '../track/blocs/track_bloc.dart' as _i9;
import '../authentication/blocs/authentication_bloc.dart' as _i10;
import 'package:firebase_messaging/firebase_messaging.dart' as _i11;
import '../signalr/signal_services.dart' as _i12;

class AppInjector$Injector implements _i1.AppInjector {
  AppInjector$Injector._(this._appModule);

  final _i2.AppModule _appModule;

  _i3.RouteRepository _singletonRouteRepository;

  _i4.TrackRepository _singletonTrackRepository;

  _i5.AuthenticationRepository _singletonAuthenticationRepository;

  static _i6.Future<_i1.AppInjector> create(_i2.AppModule appModule) async {
    final injector = AppInjector$Injector._(appModule);

    return injector;
  }

  _i7.App _createApp() => _i7.App(
      _createRouteBloc(),
      _createTrackBloc(),
      _createAuthenticationBloc(),
      _createFirebaseMessaging(),
      _createSignalrServices());
  _i8.RouteBloc _createRouteBloc() => _i8.RouteBloc(_createRouteRepository());
  _i3.RouteRepository _createRouteRepository() =>
      _singletonRouteRepository ??= _appModule.routeRepository();
  _i9.TrackBloc _createTrackBloc() => _i9.TrackBloc(_createTrackRepository());
  _i4.TrackRepository _createTrackRepository() =>
      _singletonTrackRepository ??= _appModule.trackRepository();
  _i10.AuthenticationBloc _createAuthenticationBloc() =>
      _i10.AuthenticationBloc(_createAuthenticationRepository());
  _i5.AuthenticationRepository _createAuthenticationRepository() =>
      _singletonAuthenticationRepository ??=
          _appModule.authenticationRepository();
  _i11.FirebaseMessaging _createFirebaseMessaging() =>
      _appModule.firebaseMessaging();
  _i12.SignalrServices _createSignalrServices() => _appModule.signalRService();
  @override
  _i7.App get app => _createApp();
}
