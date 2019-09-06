import 'dart:convert';
import 'package:bus_tracker_client/src/route/models/map_models/direction_response.dart';
import 'package:bus_tracker_client/src/route/models/map_models/request/geocoordinate.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
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

  Future<DirectionResponse> getDirection(GeoCordinate origin,
      GeoCordinate destination, List<GeoCordinate> wayPoints) async {
    const String api_key = "AIzaSyDJXHoRw6f7SuuH-YHHV5M03aa3wrL6SRA";
    String mapUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.lat},${origin.long}&destination=${destination.lat},${destination.long}&key=${api_key}";
    if (wayPoints != null && wayPoints.length > 0) {
      mapUrl = mapUrl +
          "&waypoints=" +
          wayPoints
              .map((wp) => "via:${wp.lat},${wp.long}")
              .join("|"); //via:10.826582,78.69311|via:10.824,78.693657"
    }

    Response response = await this._httpClient.get(mapUrl);
    dynamic direction = json.decode(response.body);
    return DirectionResponse.fromJson(direction);
  }
}
