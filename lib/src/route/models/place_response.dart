import 'package:json_annotation/json_annotation.dart';
part 'place_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class PlaceResponse{

  PlaceResponse({this.id, this.name, this.lattitude, this.longitude});

  @JsonKey(name: 'Id')
  String id;
  
  @JsonKey(name: 'Name')
  String name;

  @JsonKey(name: 'Lattitude')
  double lattitude;
  
  @JsonKey(name: 'Longitude')
  double longitude;

  Map<String, dynamic> toJson() => _$PlaceResponseToJson(this);

  factory PlaceResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceResponseFromJson(json);

  PlaceResponse toObject(Map<String, dynamic> responseJson) {
    return PlaceResponse.fromJson(responseJson);
  }
}