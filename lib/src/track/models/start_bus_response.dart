import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'start_bus_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class StartBusResponse {
  StartBusResponse({this.busId, this.id, this.currentLattitude,
      this.currentLongitude, this.startLattitude, this.startLongitude,
      this.gDirection,this.lastDestination,this.route,this.currentRouteStatus});

  @JsonKey(name: 'LastDestination')
  PlaceResponse lastDestination;

  @JsonKey(name: 'Route')
  RouteResponse route;

  @JsonKey(name: 'CurrentRouteStatus')
  PlaceResponse currentRouteStatus;

  @JsonKey(name: 'BusId')
  String busId;

  @JsonKey(name: 'Id')
  String id;

  @JsonKey(name: 'GDirection')
  String gDirection;

  @JsonKey(name: 'CurrentLattitude')
  String currentLattitude;

  @JsonKey(name: 'CurrentLongitude')
  String currentLongitude;

  @JsonKey(name: 'StartLattitude')
  String startLattitude;

  @JsonKey(name: 'StartLongitude')
  String startLongitude;

  Map<String, dynamic> toJson() => _$StartBusResponseToJson(this);

  factory StartBusResponse.fromJson(Map<String, dynamic> json) =>
      _$StartBusResponseFromJson(json);

  StartBusResponse toObject(Map<String, dynamic> responseJson) {
    return StartBusResponse.fromJson(responseJson);
  }
}
