// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) {
  return UserResponse(
    id: json['Id'] as String,
    name: json['Name'] as String,
    place: json['Place'] == null
        ? null
        : PlaceResponse.fromJson(json['Place'] as Map<String, dynamic>),
  )..routeId = json['RouteId'] as String;
}

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'RouteId': instance.routeId,
      'Place': instance.place,
    };
