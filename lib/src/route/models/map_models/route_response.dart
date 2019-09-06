

import 'package:bus_tracker_client/src/route/models/map_models/polyline_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'leg_response.dart';
part 'route_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class RouteResponse{
  RouteResponse({this.legs, this.overviewPolyline});

  @JsonKey(name: 'legs')
  List<LegResponse> legs;

  @JsonKey(name: 'overview_polyline')
  PolyLineResponse overviewPolyline;

  Map<String, dynamic> toJson() => _$RouteResponseToJson(this);

  factory RouteResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteResponseFromJson(json);

  RouteResponse toObject(Map<String, dynamic> responseJson) {
    return RouteResponse.fromJson(responseJson);
  }
}





