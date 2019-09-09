// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lat_long.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLong _$LatLongFromJson(Map<String, dynamic> json) {
  return LatLong(
    lattitude: json['Lattitude'] as String,
    longitude: json['Longitude'] == null
        ? null
        : LatLong.fromJson(json['Longitude'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LatLongToJson(LatLong instance) => <String, dynamic>{
      'Lattitude': instance.lattitude,
      'Longitude': instance.longitude,
    };
