import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
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

  updateReacedPlace(UpdateReachedPlace updateReacedPlace, bool isDestinationUpdate) async{
    print(updateReacedPlace.toJson());
    String suffix = isDestinationUpdate ? "UpdateLastDestination":"UpdateCurrentLocation";
    Response response =  await this._httpClient.put("${baseUrl}/${trackPrefix}/${suffix}",body: updateReacedPlace.toJson());
    print(response.statusCode);
    return response;
  }

  getBusRouteByUserId(String userId) async {
    Response response = await this._httpClient.get("${baseUrl}/busTracks/byUserId?userId=${userId}");
    dynamic jsonBody = json.decode(response.body);
    return BusTrackResponseDto.fromJson(jsonBody);
  }


  startBus(StartBusRequest busRequest) async{
//    Map<String,String> headers = Map();
//    headers.putIfAbsent("content-type", () => "application/x-www-form-urlencoded");
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    print(busRequest.toJson());
    Response response =  await this._httpClient.post(
        "${baseUrl}/${trackPrefix}/StartBus",
        headers: headers,
        body: json.encode(busRequest)
    );
    print(response.statusCode);
    return response;
  }

}
