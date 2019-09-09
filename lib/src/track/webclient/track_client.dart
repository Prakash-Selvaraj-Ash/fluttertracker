import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
import 'package:bus_tracker_client/src/webclient/web_client_base.dart';
import 'package:http/http.dart';
import 'package:inject/inject.dart';

class TrackClient extends WebClientBase {
  Client _httpClient;
  final String trackPrefix = "BusTracks";

  @provide
  TrackClient(this._httpClient);

  updateReacedPlace(UpdateReacedPlace updateReacedPlace) async{
//    Response response =
//    await this._httpClient.get("${baseUrl}/${trackPrefix}/${id}");
//    dynamic route = json.decode(response.body);
//    return RouteResponse.fromJson(route);
  }

}
