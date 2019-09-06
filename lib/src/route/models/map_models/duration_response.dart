import 'package:json_annotation/json_annotation.dart';
part 'duration_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class DurationResponse{
  DurationResponse({this.text, this.value});
  
  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'value')
  int value;

  Map<String, dynamic> toJson() => _$DurationResponseToJson(this);

  factory DurationResponse.fromJson(Map<String, dynamic> json) =>
      _$DurationResponseFromJson(json);

  DurationResponse toObject(Map<String, dynamic> responseJson) {
    return DurationResponse.fromJson(responseJson);
  }
}
