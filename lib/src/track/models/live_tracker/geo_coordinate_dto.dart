import 'package:json_annotation/json_annotation.dart';
part 'geo_coordinate_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class GeoCoordinateDto {
  GeoCoordinateDto({this.lattitude, this.longitude});

  @JsonKey(name: "Lattitude")
  double lattitude;

  @JsonKey(name: "Longitude")
  double longitude;

  Map<String, dynamic> toJson() => _$GeoCoordinateDtoToJson(this);

  factory GeoCoordinateDto.fromJson(Map<String, dynamic> json) =>
      _$GeoCoordinateDtoFromJson(json);

  GeoCoordinateDto toObject(Map<String, dynamic> responseJson) {
    return GeoCoordinateDto.fromJson(responseJson);
  }
}
