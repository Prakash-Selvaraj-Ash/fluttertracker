

import 'package:bus_tracker_client/src/route/models/map_models/polyline_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'leg_response.dart';
part 'map_route_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MapRouteResponse{
  MapRouteResponse({this.legs, this.overviewPolyline});

  @JsonKey(name: 'legs')
  List<LegResponse> legs;

  @JsonKey(name: 'overview_polyline')
  PolyLineResponse overviewPolyline;

  Map<String, dynamic> toJson() => _$MapRouteResponseToJson(this);

  factory MapRouteResponse.fromJson(Map<String, dynamic> json) =>
      _$MapRouteResponseFromJson(json);

  MapRouteResponse toObject(Map<String, dynamic> responseJson) {
    return MapRouteResponse.fromJson(responseJson);
  }
}





