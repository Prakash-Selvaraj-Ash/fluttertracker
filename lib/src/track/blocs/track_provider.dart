import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_current_lat_lng.dart';import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:bus_tracker_client/src/track/webclient/track_client.dart';
import 'package:inject/inject.dart';

class TrackProvider {
  TrackClient _trackClient;

  @provide
  TrackProvider(this._trackClient);

  /*Future<DirectionResponse> getDirection(GeoCordinate origin, GeoCordinate destination,
          List<GeoCordinate> wayPoints) async =>
      await _routeClient.getDirection(origin, destination, wayPoints);*/

   Future<dynamic> updateReachedPlace(UpdateReachedPlace updateReachedPlace) async =>
      await _trackClient.updateReachedPlace(updateReachedPlace);


  Future<dynamic> updateCurrentLatLng(UpdateCurrentLatLng updateCurrentLatLng) async =>
      await _trackClient.updateCurrentLatLng(updateCurrentLatLng);

  Future<BusTrackResponseDto> startBus(StartBusRequest busRequest) async =>
      await _trackClient.startBus(busRequest);

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _trackClient.getBusRouteByUserId(userId);

  Future<BusTrackResponseDto> getBusRouteByBusId(String busId) async =>
      await _trackClient.getBusRouteByBusId(busId);
}
