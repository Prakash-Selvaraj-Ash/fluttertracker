import 'package:json_annotation/json_annotation.dart';
part 'start_bus_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class StartBusRequest {
  StartBusRequest({this.busId, this.routeId, this.currentLattitude,
      this.currentLongitude, this.startLattitude, this.startLongitude});

  @JsonKey(name: 'BusId')
  String busId;

  @JsonKey(name: 'RouteId')
  String routeId;

  @JsonKey(name: 'CurrentLattitude')
  String currentLattitude;

  @JsonKey(name: 'CurrentLongitude')
  String currentLongitude;

  @JsonKey(name: 'StartLattitude')
  String startLattitude;

  @JsonKey(name: 'StartLongitude')
  String startLongitude;

  Map<String, dynamic> toJson() => _$StartBusRequestToJson(this);

  factory StartBusRequest.fromJson(Map<String, dynamic> json) =>
      _$StartBusRequestFromJson(json);

  StartBusRequest toObject(Map<String, dynamic> responseJson) {
    return StartBusRequest.fromJson(responseJson);
  }
}
