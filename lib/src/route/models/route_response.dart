import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'route_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class RouteResponse{
  RouteResponse({this.id, this.places});
  
  @JsonKey(name: 'Id')
  String id;

  @JsonKey(name: 'Places')
  List<PlaceResponse> places;

  @override
  String toString() {
    return '${places.first.name} to ${places.last.name}';
  }

  factory RouteResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteResponseFromJson(json);

  RouteResponse toObject(Map<String, dynamic> responseJson) {
    return RouteResponse.fromJson(responseJson);
  }
}