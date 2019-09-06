// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteResponse _$RouteResponseFromJson(Map<String, dynamic> json) {
  return RouteResponse(
    id: json['Id'] as String,
    places: (json['Places'] as List)
        ?.map((e) => e == null
            ? null
            : PlaceResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RouteResponseToJson(RouteResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Places': instance.places,
    };
