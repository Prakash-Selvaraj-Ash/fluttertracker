import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_current_lat_lng.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:bus_tracker_client/src/webclient/web_client_base.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:inject/inject.dart';
import 'dart:convert';

class TrackClient extends WebClientBase {
  Client _httpClient;
  final String trackPrefix = "BusTracks";

  @provide
  TrackClient(this._httpClient);

  Future<dynamic> updateReachedPlace(
      UpdateReachedPlace updateReachedPlace) async {
    print(updateReachedPlace.toJson());

    Map<String, dynamic> jsonBody = updateReachedPlace.toJson();
    Map<String, String> _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json; charset=utf-8';
    Response response = await this._httpClient.put(
        "${baseUrl}/${trackPrefix}/UpdateLastDestination",
        body: json.encode(jsonBody),
        headers: _headers);
    print(response.statusCode);
    return response.statusCode;
  }

  Future<dynamic> updateCurrentLatLng(
      UpdateCurrentLatLng updateCurrentLatLng) async {
    print(updateCurrentLatLng.toJson());

    Map<String, dynamic> jsonBody = updateCurrentLatLng.toJson();
    Map<String, String> _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json; charset=utf-8';
    Response response = await this._httpClient.put(
        "${baseUrl}/${trackPrefix}/UpdateCurrentLocation",
        body: json.encode(jsonBody),
        headers: _headers);
    print(response.statusCode);
    return response.statusCode;
  }

  Future<BusTrackResponseDto> startBus(StartBusRequest busRequest) async {
    Map<String, dynamic> jsonBody = busRequest.toJson();
    Map<String, String> _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json; charset=utf-8';
    print(busRequest.toJson());
    Response response = await this._httpClient.post(
        "${baseUrl}/${trackPrefix}/StartBus",
        headers: _headers,
        body: json.encode(jsonBody));
    print(response.statusCode);
    dynamic jsonResponse = json.decode(response.body);
    return BusTrackResponseDto.fromJson(jsonResponse);
  }

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async {
    Response response = await this._httpClient.get("${baseUrl}/busTracks/byUserId?userId=${userId}");
    dynamic jsonBody = json.decode(response.body);
    print(jsonBody);
    return BusTrackResponseDto.fromJson(jsonBody);
  }

  Future<BusTrackResponseDto> getBusRouteByBusId(String busId) async{
    Response response = await this._httpClient.get("${baseUrl}/${trackPrefix}/byBusId?busId=${busId}");
//  Response response = await this._httpClient.get("http://www.mocky.io/v2/5d78ab3e320000cfe2924390");
    if(response.statusCode == 200) {
      dynamic jsonBody = json.decode(response.body);
      print(jsonBody);
      return BusTrackResponseDto.fromJson(jsonBody);
    }else{
      print(response.statusCode);
      return null;
    }
  }

}
