import 'package:bus_tracker_client/src/track/blocs/track_provider.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:inject/inject.dart';

class TrackRepository {
  final TrackProvider _trackProvider;

  @provide
  TrackRepository(this._trackProvider);

  Future<dynamic> updateReacedPlace(
      UpdateReacedPlace updateReacedPlace) async =>
      await _trackProvider.updateReacedPlace(updateReacedPlace);

}