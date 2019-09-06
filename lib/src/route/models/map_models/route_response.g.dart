// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteResponse _$RouteResponseFromJson(Map<String, dynamic> json) {
  return RouteResponse(
    legs: (json['legs'] as List)
        ?.map((e) =>
            e == null ? null : LegResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    overviewPolyline: json['overview_polyline'] == null
        ? null
        : PolyLineResponse.fromJson(
            json['overview_polyline'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RouteResponseToJson(RouteResponse instance) =>
    <String, dynamic>{
      'legs': instance.legs,
      'overview_polyline': instance.overviewPolyline,
    };
