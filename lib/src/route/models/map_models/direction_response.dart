import 'package:bus_tracker_client/src/route/models/map_models/route_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'direction_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class DirectionResponse{
  DirectionResponse({this.routes});
  
  @JsonKey(name: 'routes')
  List<RouteResponse> routes;

  Map<String, dynamic> toJson() => _$DirectionResponseToJson(this);

  factory DirectionResponse.fromJson(Map<String, dynamic> json) =>
      _$DirectionResponseFromJson(json);

  DirectionResponse toObject(Map<String, dynamic> responseJson) {
    return DirectionResponse.fromJson(responseJson);
  }

}