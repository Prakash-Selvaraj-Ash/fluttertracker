
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response_eta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'geo_coordinate_dto.dart';


part 'live_track_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LiveTrackResponseDto {
  LiveTrackResponseDto(
      {this.lastDestination, this.currentLocationCoordinate, this.places});

  @JsonKey(name: "LastDestination")
  PlaceResponse lastDestination;

  @JsonKey(name: "CurrentLocationCoordinate")
  GeoCoordinateDto currentLocationCoordinate;

  @JsonKey(name: "Places")
  List<PlaceWithEtaResponse> places;

  Map<String, dynamic> toJson() => _$LiveTrackResponseDtoToJson(this);

  factory LiveTrackResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LiveTrackResponseDtoFromJson(json);

  LiveTrackResponseDto toObject(Map<String, dynamic> responseJson) {
    return LiveTrackResponseDto.fromJson(responseJson);
  }
}
