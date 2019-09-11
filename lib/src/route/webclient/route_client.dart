import 'dart:convert';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/webclient/web_client_base.dart';
import 'package:http/http.dart';
import 'package:inject/inject.dart';

class RouteClient extends WebClientBase {
  Client _httpClient;
  final String routePrefix = "routes";

  @provide
  RouteClient(this._httpClient);

  Future<List<RouteResponse>> getAllRoutes() async {
    Response response = await this._httpClient.get("${baseUrl}/${routePrefix}");
    List<dynamic> routes = json.decode(response.body);
    return routes.map((route) => RouteResponse.fromJson(route)).toList();
  }

  Future<RouteResponse> getRouteById(String id) async {
    Response response =
        await this._httpClient.get("${baseUrl}/${routePrefix}/${id}");
    dynamic route = json.decode(response.body);
    return RouteResponse.fromJson(route);
  }

  Future<BusTrackResponseDto> getBusRouteByUserId(String userId) async {
    Response response = 
      await this._httpClient.get("${baseUrl}/busTracks/byUserId?userId=${userId}");
    print(response.body);
    dynamic jsonBody = json.decode(response.body);
    return BusTrackResponseDto.fromJson(jsonBody);
  }
}
