import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/signalr/signal_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app.dart';
import './line_track.dart';
import './map_track.dart';
import 'dart:math' show cos, sqrt, asin;

class BusTrack extends StatefulWidget {
  final String _routeId;
  final RouteBloc _routeBloc;
  final SignalrServices _signalrServices;
  RouteResponse _routeResponse;
  LatLng _currentLatLng;
  final bool _isDriver;

  BusTrack(
      this._routeId, this._routeBloc, this._signalrServices, this._isDriver);

  LatLng get _initialLatLng {
    return LatLng(_routeResponse.places[0].lattitude + 0.002,
        _routeResponse.places[0].longitude + 0.002);
  }

  LatLng get _finalLatLng {
    return LatLng(
        _routeResponse.places[_routeResponse.places.length - 1].lattitude,
        _routeResponse.places[_routeResponse.places.length - 1].longitude);
  }

  double _calculateDistance(LatLng origin, LatLng destination){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((destination.latitude - origin.latitude) * p)/2 +
        c(origin.latitude * p) * c(destination.latitude * p) *
            (1 - c((destination.longitude - origin.longitude) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  _BusTrackState createState() => _BusTrackState();
}

class _BusTrackState extends State<BusTrack> {
  @override
  void initState() {
    super.initState();
    initializeRoutes();
    if (widget._isDriver) {
      initLocationUpdates();
    } else {
      initSignalRListener();
    }
  }

  void initLocationUpdates() async {
    if (widget._currentLatLng == null) {
      widget._currentLatLng = widget._initialLatLng;
    }
    /*print(widget._calculateDistance(
        widget._currentLatLng,
    LatLng(widget._routeResponse.places[0].lattitude+ 0.002,
        widget._routeResponse.places[0].longitude+ 0.0019)));*/
  }

  void initSignalRListener() {
    widget._signalrServices.initialize(_handleBroadCastMessage);
    widget._signalrServices.start(App.user.id);
  }

  void _handleBroadCastMessage(List<Object> parameters) {
    print(parameters);
  }

  RouteResponse get listRes {
    RouteResponse response;
    if (App.routeResonse != null) {
      for (final routeResponse in App.routeResonse) {
        if (routeResponse.id == widget._routeId) {
          response = routeResponse;
        }
      }
    }
    return response;
  }

  void initializeRoutes() async {
    RouteResponse places;
    if (listRes == null) {
      places = await widget._routeBloc.getRouteById(widget._routeId);
    } else {
      places = listRes;
    }
    setState(() {
      widget._routeResponse = places;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Bus Tracking'),
            bottom: TabBar(
              tabs: [
                Icon(Icons.linear_scale),
                Icon(Icons.map),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              LineTrack(widget._routeResponse, widget._currentLatLng),
              MapTrack(widget._routeResponse, widget._currentLatLng),
            ],
          ),
        ));
  }
}
