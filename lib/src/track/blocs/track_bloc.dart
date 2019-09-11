import 'package:bus_tracker_client/src/blocs/bloc_base.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/update_current_lat_lng.dart';
import 'package:bus_tracker_client/src/track/resources/track_repository.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:inject/inject.dart';

class TrackBloc extends BlocBase {
  final TrackRepository _trackRepository;

  @provide
  TrackBloc(this._trackRepository);

  Future<BusTrackResponseDto> startBus(StartBusRequest busRequest) async{
    await _trackRepository.startBus(busRequest);
  }

  Future<dynamic> updateReachedPlace(UpdateReachedPlace updateReachedPlace) async{
    await _trackRepository.updateReachedPlace(updateReachedPlace);
  }

  Future<dynamic> updateCurrentLatLng(UpdateCurrentLatLng updateCurrentLatLng) async{
    await _trackRepository.updateCurrentLatLng(updateCurrentLatLng);
  }

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async =>
    await _trackRepository.getBusRouteByUserId(userId);

  Future<BusTrackResponseDto> getBusRouteByBusId(String busId) async =>
      await _trackRepository.getBusRouteByBusId(busId);

  @override
  void dispose() {}
}
