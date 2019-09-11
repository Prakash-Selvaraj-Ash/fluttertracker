import 'package:bus_tracker_client/src/track/blocs/track_provider.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_current_lat_lng.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:inject/inject.dart';

class TrackRepository {
  final TrackProvider _trackProvider;

  @provide
  TrackRepository(this._trackProvider);

  Future<dynamic> updateReachedPlace(
      UpdateReachedPlace updateReachedPlace) async =>
      await _trackProvider.updateReachedPlace(updateReachedPlace);

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _trackProvider.getBusRouteByUserId(userId);

  Future<BusTrackResponseDto> startBus(StartBusRequest busRequest)  async =>
      await _trackProvider.startBus(busRequest);

  Future<BusTrackResponseDto> getBusRouteByBusId(String busId) async =>
      await _trackProvider.getBusRouteByBusId(busId);

  Future<dynamic> updateCurrentLatLng(
      UpdateCurrentLatLng updateCurrentLatLng) async =>
      await _trackProvider.updateCurrentLatLng(updateCurrentLatLng);

}
