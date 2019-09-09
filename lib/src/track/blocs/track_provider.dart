import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:bus_tracker_client/src/track/webclient/track_client.dart';
import 'package:inject/inject.dart';

class TrackProvider {
  TrackClient _trackClient;

  @provide
  TrackProvider(this._trackClient);

  /*Future<DirectionResponse> getDirection(GeoCordinate origin, GeoCordinate destination,
          List<GeoCordinate> wayPoints) async =>
      await _routeClient.getDirection(origin, destination, wayPoints);*/

  Future<RouteResponse> updateReacedPlace(UpdateReacedPlace updateReacedPlace) async =>
      await _trackClient.updateReacedPlace(updateReacedPlace);
}