import 'package:bus_tracker_client/src/blocs/bloc_base.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/resources/track_repository.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:inject/inject.dart';

class TrackBloc extends BlocBase {
  final TrackRepository _trackRepository;

  @provide
  TrackBloc(this._trackRepository);

  startBus(StartBusRequest busRequest) async{
    dynamic response = await _trackRepository.startBus(busRequest);
  }

  updatePlace(UpdateReachedPlace updateReacedPlace, bool isDestinationUpdate) async{
    dynamic response = await _trackRepository.updateReacedPlace(updateReacedPlace,isDestinationUpdate);
  }

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _trackRepository.getBusRouteByUserId(userId);

  @override
  void dispose() {}
}
