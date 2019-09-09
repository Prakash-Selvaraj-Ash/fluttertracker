import 'package:json_annotation/json_annotation.dart';
part 'lat_long.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LatLong {

  LatLong({this.lattitude,this.longitude});

  @JsonKey(name: 'Lattitude')
  String lattitude;

  @JsonKey(name: 'Longitude')
  LatLong longitude;

  Map<String, dynamic> toJson() => _$LatLongToJson(this);

  factory LatLong.fromJson(Map<String, dynamic> json) =>
      _$LatLongFromJson(json);

  LatLong toObject(Map<String, dynamic> responseJson) {
    return LatLong.fromJson(responseJson);
  }

}