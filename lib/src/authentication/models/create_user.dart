import 'package:json_annotation/json_annotation.dart';
part 'create_user.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CreateUser {
  CreateUser({this.name, this.placeId, this.routeId, this.fcmId});

  @JsonKey(name: 'Name')
  String name;

  @JsonKey(name: 'PlaceId')
  String placeId;

  @JsonKey(name: 'RouteId')
  String routeId;

  @JsonKey(name:'FcmId')
  String fcmId;

  Map<String, dynamic> toJson() => _$CreateUserToJson(this);

  factory CreateUser.fromJson(Map<String, dynamic> json) =>
      _$CreateUserFromJson(json);

  CreateUser toObject(Map<String, dynamic> responseJson) {
    return CreateUser.fromJson(responseJson);
  }
}
