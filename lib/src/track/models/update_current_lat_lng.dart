import 'package:json_annotation/json_annotation.dart';
import 'package:bus_tracker_client/src/track/models/lat_long.dart';
part 'update_current_lat_lng.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UpdateCurrentLatLng{
  UpdateCurrentLatLng({this.busId,this.currentLocation});

  @JsonKey(name: 'BusId')
  String busId;

  @JsonKey(name: 'CurrentLocation')
  LatLong currentLocation;

  Map<String, dynamic> toJson() => _$UpdateCurrentLatLngToJson(this);

  factory UpdateCurrentLatLng.fromJson(Map<String, dynamic> json) =>
      _$UpdateCurrentLatLngFromJson(json);

  UpdateCurrentLatLng toObject(Map<String, dynamic> responseJson) {
    return UpdateCurrentLatLng.fromJson(responseJson);
  }
}