import 'dart:async';

import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/map_models/direction_response.dart';
import 'package:bus_tracker_client/src/route/models/map_models/request/geocoordinate.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/signalr/signal_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*class MapTrackOld extends StatefulWidget {
  final UserResponse user;
  final RouteBloc routeBloc;
  final SignalrServices signalrServices;
  final RouteResponse _routeResponse;

  MapTrackOld(this.user,this._routeResponse, this.routeBloc, this.signalrServices);

  @override
  State<MapTrackOld> createState() => _MapTrackOldState();
}

class _MapTrackOldState extends State<MapTrackOld> {
  BitmapDescriptor myIcon;
  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> latlng = [];
  List<PlaceResponse> placeResponses;
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    //target: LatLng(lat, long),
    zoom: 14.4746,
  );

  @override
  void initState() {
    initGMap();
    initRoutes();
    initBusIcon();
    initSignalR();
    super.initState();
  }

  void initGMap() {
    double lat = widget.user.place.lattitude;
    double long = widget.user.place.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget._routeResponse == null
        ? Center(
            child: CircularProgressIndicator(
              value: 60,
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'eMTe School',
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontFamily: 'Precious'),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    polylines: _polylines,
                    markers: _markers.values.toSet(),
                  ),
                ),
              ],
            ),
          );
  }

  void initRoutes() async {
//    RouteResponse route =
//        await widget.routeBloc.getRouteById(widget.user.routeId);
    GeoCordinate origin = GeoCordinate(
        lat: widget._routeResponse.places.first.lattitude, long: widget._routeResponse.places.first.longitude);

    GeoCordinate destination = GeoCordinate(
        lat: widget.user.place.lattitude, long: widget.user.place.longitude);

    List<GeoCordinate> wayPoints = getWayPoints(widget._routeResponse.places);

    DirectionResponse direction =
        await widget.routeBloc.getDirection(origin, destination, wayPoints);

    var polyLines =
        decodeEncodedPolyline(direction.routes.first.overviewPolyline.points);
    for (var poly in polyLines) {
      setState(() {
        latlng.add(poly);
        _polylines.add(Polyline(
          polylineId: PolylineId(widget.user.id.toString()),
          visible: true,
          points: latlng,
          width: 3,
          color: Colors.black,
        ));
      });
    }

    for (var place in widget._routeResponse.places) {
      if (place.id == widget.user.place.id) {
        final destinationMarker = Marker(
          markerId: MarkerId(widget.user.place.name),
          position:
              LatLng(widget.user.place.lattitude, widget.user.place.longitude),
          infoWindow: InfoWindow(
            title: widget.user.place.name,
            snippet: 'ETA: ${direction.routes.first.legs.first.duration.text}',
          ),
        );
        _markers[widget.user.place.id] = destinationMarker;
        return;
      }

      setState(() {
        _markers[place.id] = Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lattitude, place.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: widget.user.name,
          ),
        );
      });
    }
  }

  void initBusIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/my_icon.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  List<GeoCordinate> getWayPoints(List<PlaceResponse> places) {
    List<GeoCordinate> wayPoints = List<GeoCordinate>();
    for (var place in places) {
      if (widget.user.place.id == place.id) {
        return wayPoints;
      }
      wayPoints.add(GeoCordinate(lat: place.lattitude, long: place.longitude));
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = new LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  void initSignalR() {
    widget.signalrServices.initialize(_handleBroadCastMessage);
    widget.signalrServices.start(widget.user.id);
  }

  void _handleBroadCastMessage(List<Object> parameters) {
    print(parameters);
  }
}*/
