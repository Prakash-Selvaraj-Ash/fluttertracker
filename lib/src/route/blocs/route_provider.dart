import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/webclient/route_client.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:inject/inject.dart';

class RouteProvider {
  RouteClient _routeClient;

  @provide
  RouteProvider(this._routeClient);

  Future<List<RouteResponse>> getAllRoutes() async {

    return await _routeClient.getAllRoutes();
  }

  Future<RouteResponse> getRouteById(String id) async =>
      await _routeClient.getRouteById(id);

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _routeClient.getBusRouteByUserId(userId);

}
