// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_response_eta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceWithEtaResponse _$PlaceWithEtaResponseFromJson(Map<String, dynamic> json) {
  return PlaceWithEtaResponse(
    id: json['Id'] as String,
    name: json['Name'] as String,
    lattitude: (json['Lattitude'] as num)?.toDouble(),
    longitude: (json['Longitude'] as num)?.toDouble(),
    duration: (json['Duration'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PlaceWithEtaResponseToJson(
        PlaceWithEtaResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Lattitude': instance.lattitude,
      'Longitude': instance.longitude,
      'Duration': instance.duration,
    };
