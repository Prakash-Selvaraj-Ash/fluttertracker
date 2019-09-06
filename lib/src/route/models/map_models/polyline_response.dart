
import 'package:json_annotation/json_annotation.dart';
part 'polyline_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class PolyLineResponse{

  PolyLineResponse({this.points});
  
  @JsonKey(name: 'points')
  String points;

  Map<String, dynamic> toJson() => _$PolyLineResponseToJson(this);

  factory PolyLineResponse.fromJson(Map<String, dynamic> json) =>
      _$PolyLineResponseFromJson(json);

  PolyLineResponse toObject(Map<String, dynamic> responseJson) {
    return PolyLineResponse.fromJson(responseJson);
  }
}