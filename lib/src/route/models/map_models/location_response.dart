import 'package:json_annotation/json_annotation.dart';
part 'location_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LocationResponse{
  LocationResponse({this.lat, this.long});

  @JsonKey(name: 'lat')
  double lat;

  @JsonKey(name:'long')
  double long;
  
  
  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);

  LocationResponse toObject(Map<String, dynamic> responseJson) {
    return LocationResponse.fromJson(responseJson);
  }
}