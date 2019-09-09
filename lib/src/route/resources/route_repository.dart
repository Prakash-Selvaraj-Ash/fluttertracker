import 'package:bus_tracker_client/src/route/blocs/route_provider.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:inject/inject.dart';

class RouteRepository {
  final RouteProvider _routeProvider;

  @provide
  RouteRepository(this._routeProvider);

  Future<List<RouteResponse>> getAllRoutes() => _routeProvider.getAllRoutes();

  Future<RouteResponse> getRouteById(String id) async =>
      await _routeProvider.getRouteById(id);

}
