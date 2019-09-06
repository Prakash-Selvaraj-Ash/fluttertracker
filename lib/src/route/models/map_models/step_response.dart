import 'package:json_annotation/json_annotation.dart';

import 'polyline_response.dart';

import 'distance_response.dart';
import 'duration_response.dart';
import 'location_response.dart';
part 'step_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class StepResponse {
  StepResponse(
      {this.distance,
      this.duration,
      this.startLocation,
      this.endLocation,
      this.polyline});

  @JsonKey(name: 'distance')
  DistanceResponse distance;

  @JsonKey(name: 'duration')
  DurationResponse duration;

  @JsonKey(name: 'start_location')
  LocationResponse startLocation;

  @JsonKey(name: 'end_location')
  LocationResponse endLocation;

  @JsonKey(name: 'polyline')
  PolyLineResponse polyline;

  Map<String, dynamic> toJson() => _$StepResponseToJson(this);

  factory StepResponse.fromJson(Map<String, dynamic> json) =>
      _$StepResponseFromJson(json);

  StepResponse toObject(Map<String, dynamic> responseJson) {
    return StepResponse.fromJson(responseJson);
  }
}
