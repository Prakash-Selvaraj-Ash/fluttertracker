// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationResponse _$LocationResponseFromJson(Map<String, dynamic> json) {
  return LocationResponse(
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LocationResponseToJson(LocationResponse instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };
