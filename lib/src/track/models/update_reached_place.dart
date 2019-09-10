import 'package:json_annotation/json_annotation.dart';
import 'package:bus_tracker_client/src/track/models/lat_long.dart';
part 'update_reached_place.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UpdateReachedPlace{
  UpdateReachedPlace({this.busId,this.lastDestinationId,this.currentLocation});

  @JsonKey(name: 'BusId')
  String busId;

  @JsonKey(name: 'CurrentLocation')
  LatLong currentLocation;

  @JsonKey(name: 'LastDestinationId')
  String lastDestinationId;

  Map<String, dynamic> toJson() => _$UpdateReachedPlaceToJson(this);

  factory UpdateReachedPlace.fromJson(Map<String, dynamic> json) =>
      _$UpdateReachedPlaceFromJson(json);

  UpdateReachedPlace toObject(Map<String, dynamic> responseJson) {
    return UpdateReachedPlace.fromJson(responseJson);
  }
}