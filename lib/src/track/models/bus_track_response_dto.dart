import 'dart:convert';
import 'package:bus_tracker_client/src/route/models/map_models/direction_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response_eta.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bus_track_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BusTrackResponseDto{

  BusTrackResponseDto({
    this.id, 
    this.busId,
    this.lastDestination, 
    this.routeResponse, 
    this.startLattitude,
    this.startLongitude,
    this.currentLattitude,
    this.currentLongitude,
    this.currentRouteStatus,
    this.gDirection
    });
  
  @JsonKey(name: "Id")
  String id;

  @JsonKey(name: "BusId")
  String busId;

  @JsonKey(name: "LastDestination")
  PlaceResponse lastDestination;

  @JsonKey(name: "Route")
  RouteResponse routeResponse;

  @JsonKey(name: "CurrentLattitude")
  double currentLattitude;

  @JsonKey(name: "CurrentLongitude")
  double currentLongitude;

  @JsonKey(name: "StartLattitude")
  double startLattitude;

  @JsonKey(name: "StartLongitude")
  double startLongitude;

  @JsonKey(name: "GDirection")
  String gDirection;

  DirectionResponse get directionResponse
  {
    return gDirection == null ? null : DirectionResponse.fromJson(
            json.decode(gDirection) as Map<String, dynamic>);
  }

  @JsonKey(name: "CurrentRouteStatus")
  List<PlaceWithEtaResponse> currentRouteStatus;

  Map<String, dynamic> toJson() => _$BusTrackResponseDtoToJson(this);

  factory BusTrackResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BusTrackResponseDtoFromJson(json);

  BusTrackResponseDto toObject(Map<String, dynamic> responseJson) {
    return BusTrackResponseDto.fromJson(responseJson);
  }
}