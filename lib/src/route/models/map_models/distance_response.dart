import 'package:json_annotation/json_annotation.dart';
part 'distance_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class DistanceResponse{
  DistanceResponse({this.text, this.value});
  
  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'value')
  int value;

  Map<String, dynamic> toJson() => _$DistanceResponseToJson(this);

  factory DistanceResponse.fromJson(Map<String, dynamic> json) =>
      _$DistanceResponseFromJson(json);

  DistanceResponse toObject(Map<String, dynamic> responseJson) {
    return DistanceResponse.fromJson(responseJson);
  }
}
