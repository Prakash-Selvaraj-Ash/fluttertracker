import 'package:bus_tracker_client/src/route/blocs/route_provider.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:inject/inject.dart';

class RouteRepository {
  final RouteProvider _routeProvider;

  @provide
  RouteRepository(this._routeProvider);

  Future<List<RouteResponse>> getAllRoutes() => _routeProvider.getAllRoutes();

  Future<RouteResponse> getRouteById(String id) async =>
      await _routeProvider.getRouteById(id);

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _routeProvider.getBusRouteByUserId(userId);
}
