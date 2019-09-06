import 'package:json_annotation/json_annotation.dart';

import 'distance_response.dart';
import 'duration_response.dart';
import 'location_response.dart';
import 'step_response.dart';
part 'leg_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LegResponse {
  LegResponse({this.distance, this.duration, this.startLocation, this.endLocation, this.steps});

  @JsonKey(name: 'distance')
  DistanceResponse distance;
  
  @JsonKey(name: 'duration')
  DurationResponse duration;
  
  @JsonKey(name: 'start_location')
  LocationResponse startLocation;

  @JsonKey(name: 'end_location')
  LocationResponse endLocation;
  
  @JsonKey(name: 'steps')
  List<StepResponse> steps;

  
  Map<String, dynamic> toJson() => _$LegResponseToJson(this);

  factory LegResponse.fromJson(Map<String, dynamic> json) =>
      _$LegResponseFromJson(json);

  LegResponse toObject(Map<String, dynamic> responseJson) {
    return LegResponse.fromJson(responseJson);
  }
}
