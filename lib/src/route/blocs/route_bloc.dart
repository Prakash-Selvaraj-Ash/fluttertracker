import 'package:bus_tracker_client/src/blocs/bloc_base.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/resources/route_repository.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:inject/inject.dart';

class RouteBloc extends BlocBase {
  final RouteRepository _routeRepository;

  @provide
  RouteBloc(this._routeRepository);

  getAllRoutes() async {
    List<RouteResponse> routes = await _routeRepository.getAllRoutes();
    return routes;
  }

  getRouteById(String routeId) async {
    RouteResponse route = await _routeRepository.getRouteById(routeId);
    return route;
  }

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _routeRepository.getBusRouteByUserId(userId);

  @override
  void dispose() {}
}
