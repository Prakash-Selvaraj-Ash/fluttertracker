// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceResponse _$PlaceResponseFromJson(Map<String, dynamic> json) {
  return PlaceResponse(
    id: json['Id'] as String,
    name: json['Name'] as String,
    lattitude: (json['Lattitude'] as num)?.toDouble(),
    longitude: (json['Longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PlaceResponseToJson(PlaceResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Lattitude': instance.lattitude,
      'Longitude': instance.longitude,
    };
