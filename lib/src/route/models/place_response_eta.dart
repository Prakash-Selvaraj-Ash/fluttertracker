import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'place_response_eta.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class PlaceWithEtaResponse{
  PlaceWithEtaResponse({this.id, this.name, this.lattitude, this.longitude, this.duration});

  @JsonKey(name: 'Id')
  String id;

  @JsonKey(name: 'Name')
  String name;

  @JsonKey(name: 'Lattitude')
  double lattitude;

  @JsonKey(name: 'Longitude')
  double longitude;

  @JsonKey(name: "Duration")
  double duration;

  Map<String, dynamic> toJson() => _$PlaceWithEtaResponseToJson(this);

  factory PlaceWithEtaResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceWithEtaResponseFromJson(json);

  PlaceWithEtaResponse toObject(Map<String, dynamic> responseJson) {
    return PlaceWithEtaResponse.fromJson(responseJson);
  }
}
