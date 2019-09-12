// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_coordinate_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoCoordinateDto _$GeoCoordinateDtoFromJson(Map<String, dynamic> json) {
  return GeoCoordinateDto(
    lattitude: (json['Lattitude'] as num)?.toDouble(),
    longitude: (json['Longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$GeoCoordinateDtoToJson(GeoCoordinateDto instance) =>
    <String, dynamic>{
      'Lattitude': instance.lattitude,
      'Longitude': instance.longitude,
    };
