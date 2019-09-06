import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserResponse {
  UserResponse({this.id, this.name, this.place});

  @JsonKey(name: 'Id')
  String id;

  @JsonKey(name: 'Name')
  String name;

  @JsonKey(name: 'RouteId')
  String routeId;

  @JsonKey(name: 'Place')
  PlaceResponse place;

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  UserResponse toObject(Map<String, dynamic> responseJson) {
    return UserResponse.fromJson(responseJson);
  }
}
