import 'package:bus_tracker_client/src/track/blocs/track_provider.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:inject/inject.dart';

class TrackRepository {
  final TrackProvider _trackProvider;

  @provide
  TrackRepository(this._trackProvider);

  Future<dynamic> updateReacedPlace(
      UpdateReachedPlace updateReacedPlace, bool isDestinationUpdate) async =>
      await _trackProvider.updateReacedPlace(updateReacedPlace,isDestinationUpdate);

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _trackProvider.getBusRouteByUserId(userId);

  Future<dynamic> startBus(StartBusRequest busRequest)  async =>
      await _trackProvider.startBus(busRequest);

}
