// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUser _$CreateUserFromJson(Map<String, dynamic> json) {
  return CreateUser(
    name: json['Name'] as String,
    placeId: json['PlaceId'] as String,
    routeId: json['RouteId'] as String,
    fcmId: json['FcmId'] as String,
  );
}

Map<String, dynamic> _$CreateUserToJson(CreateUser instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'PlaceId': instance.placeId,
      'RouteId': instance.routeId,
      'FcmId': instance.fcmId,
    };
