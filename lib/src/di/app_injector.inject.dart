import 'app_injector.dart' as _i1;
import 'app_module.dart' as _i2;
import '../route/resources/route_repository.dart' as _i3;
import '../authentication/resources/authentication_repository.dart' as _i4;
import 'dart:async' as _i5;
import '../../app.dart' as _i6;
import '../route/blocs/route_bloc.dart' as _i7;
import '../authentication/blocs/authentication_bloc.dart' as _i8;
import 'package:firebase_messaging/firebase_messaging.dart' as _i9;
import '../signalr/signal_services.dart' as _i10;

class AppInjector$Injector implements _i1.AppInjector {
  AppInjector$Injector._(this._appModule);

  final _i2.AppModule _appModule;

  _i3.RouteRepository _singletonRouteRepository;

  _i4.AuthenticationRepository _singletonAuthenticationRepository;

  static _i5.Future<_i1.AppInjector> create(_i2.AppModule appModule) async {
    final injector = AppInjector$Injector._(appModule);

    return injector;
  }

  _i6.App _createApp() => _i6.App(
      _createRouteBloc(),
      _createAuthenticationBloc(),
      _createFirebaseMessaging(),
      _createSignalrServices());
  _i7.RouteBloc _createRouteBloc() => _i7.RouteBloc(_createRouteRepository());
  _i3.RouteRepository _createRouteRepository() =>
      _singletonRouteRepository ??= _appModule.routeRepository();
  _i8.AuthenticationBloc _createAuthenticationBloc() =>
      _i8.AuthenticationBloc(_createAuthenticationRepository());
  _i4.AuthenticationRepository _createAuthenticationRepository() =>
      _singletonAuthenticationRepository ??=
          _appModule.authenticationRepository();
  _i9.FirebaseMessaging _createFirebaseMessaging() =>
      _appModule.firebaseMessaging();
  _i10.SignalrServices _createSignalrServices() => _appModule.signalRService();
  @override
  _i6.App get app => _createApp();
}
