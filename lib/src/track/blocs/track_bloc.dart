import 'package:bus_tracker_client/src/blocs/bloc_base.dart';
import 'package:bus_tracker_client/src/track/resources/track_repository.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:inject/inject.dart';

class TrackBloc extends BlocBase {
  final TrackRepository _trackRepository;

  @provide
  TrackBloc(this._trackRepository);

  startBus(StartBusRequest busRequest) async{

  }

  updatePlace(UpdateReacedPlace updateReacedPlace) async{
    dynamic response = await _trackRepository.updateReacedPlace(updateReacedPlace);
  }

  @override
  void dispose() {}
}