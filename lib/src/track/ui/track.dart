import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response_eta.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/blocs/track_bloc.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/lat_long.dart';
import 'package:bus_tracker_client/src/track/models/start_bus_request.dart';
import 'package:bus_tracker_client/src/track/models/update_current_lat_lng.dart';
import 'package:bus_tracker_client/src/track/models/update_reached_place.dart';
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
  final TrackBloc _trackBloc;
  final SignalrServices _signalrServices;
  RouteResponse _routeResponse;
  LatLng _currentLatLng;
  final bool _isDriver;
  BusTrackResponseDto _trackData;
  Map<String, String> _etaForPlaces = Map();
  bool _showNotStarted = false;

  BusTrack(this._routeId, this._routeBloc, this._trackBloc,
      this._signalrServices, this._isDriver);

  LatLng get _initialLatLng {
    return LatLng(_routeResponse.places[0].lattitude + 0.002,
        _routeResponse.places[0].longitude + 0.002);
  }

  LatLng get _finalLatLng {
    return LatLng(
        _routeResponse.places[_routeResponse.places.length - 1].lattitude,
        _routeResponse.places[_routeResponse.places.length - 1].longitude);
  }

  double _calculateDistance(LatLng origin, LatLng destination) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((destination.latitude - origin.latitude) * p) / 2 +
        c(origin.latitude * p) *
            c(destination.latitude * p) *
            (1 - c((destination.longitude - origin.longitude) * p)) /
            2;
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
  }

  void initializeRoutes() async {
    RouteResponse places;
    print(listRes);
    if (listRes == null || !widget._isDriver) {
      places = await widget._routeBloc.getRouteById(widget._routeId);
    } else {
      places = listRes;
    }
    setState(() {
      widget._routeResponse = places;
      initializeTrackData();
    });
  }

  void initializeTrackData() async {
    var res = await widget._trackBloc
        .getBusRouteByBusId(App.BUS_IDS[widget._routeId]);
    setState(() {
      widget._trackData = res;

//      widget._trackData.lastDestination = widget._routeResponse.places[3];
//      widget._trackData.currentLattitude = widget._routeResponse.places[2].lattitude;
//      widget._trackData.currentLongitude = widget._routeResponse.places[2].longitude;

      if (widget._isDriver) {
        initLocationUpdates();
      } else {
        if (widget._trackData != null) {
          parseTrackData();
        } else {
          widget._showNotStarted = true;
        }
//        initSignalRListener();
      }
    });
  }

  void initLocationUpdates() {
    if (widget._trackData == null) {
      if (widget._currentLatLng == null) {
        setState(() {
          widget._currentLatLng = widget._initialLatLng;
        });
      }
      updateBusStarted();
    } else {
      parseTrackData();
      startLocationUpdateTimer();
    }
  }

  void startLocationUpdateTimer() {

  }

  void parseTrackData() {
    setState(() {
      widget._etaForPlaces = setEtaForPlaces();
      widget._currentLatLng = LatLng(widget._trackData.currentLattitude,
          widget._trackData.currentLongitude);
    });
  }

  Map<String, String> setEtaForPlaces() {
    Map<String, String> etas = Map();
    if (widget._trackData.currentRouteStatus != null &&
        widget._trackData.currentRouteStatus.length > 0) {
      for (PlaceWithEtaResponse placeResponse
          in widget._trackData.currentRouteStatus) {
        print(placeResponse.name);
        etas.putIfAbsent(placeResponse.id,
            () => (placeResponse.duration.toStringAsFixed(1) + " min"));
      }
    }
    print(etas);
    return etas;
  }

  void updateBusStarted() async {
    StartBusRequest busRequest = StartBusRequest(
      busId: App.BUS_IDS[widget._routeId],
      routeId: widget._routeId,
      currentLattitude: widget._currentLatLng.latitude.toString(),
      currentLongitude: widget._currentLatLng.longitude.toString(),
      startLattitude: widget._currentLatLng.latitude.toString(),
      startLongitude: widget._currentLatLng.longitude.toString(),
    );
    var response = await widget._trackBloc.startBus(busRequest);
    print(response);
    setState(() {
      widget._trackData = response;
      if (widget._trackData != null) {
        parseTrackData();
        startLocationUpdateTimer();
      }
    });
  }

  void updateCurrentLocation() async {
    UpdateCurrentLatLng updateCurrentLatLng = UpdateCurrentLatLng(
        busId: App.BUS_IDS[widget._routeId],
        currentLocation: LatLong(
          lattitude: widget._currentLatLng.latitude.toString(),
          longitude: widget._currentLatLng.longitude.toString(),
        ));
    dynamic response =
        await widget._trackBloc.updateCurrentLatLng(updateCurrentLatLng);
    print(response);
  }

  void updateReachedPlace(String destinationId) async {
    UpdateReachedPlace updateReachedPlace = UpdateReachedPlace(
        busId: App.BUS_IDS[widget._routeId],
        lastDestinationId: destinationId,
        currentLocation: LatLong(
          lattitude: widget._currentLatLng.latitude.toString(),
          longitude: widget._currentLatLng.longitude.toString(),
        ));
    dynamic response =
        await widget._trackBloc.updateReachedPlace(updateReachedPlace);
    print(response);
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
              LineTrack(
                  widget._routeResponse,
                  widget._currentLatLng,
                  widget._trackData,
                  widget._etaForPlaces,
                  widget._showNotStarted),
              MapTrack(
                  widget._routeResponse,
                  widget._currentLatLng,
                  widget._trackData,
                  widget._etaForPlaces,
                  widget._showNotStarted),
            ],
          ),
        ));
  }
}
