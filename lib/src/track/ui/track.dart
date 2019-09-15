import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response_eta.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/blocs/track_bloc.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:bus_tracker_client/src/track/models/lat_long.dart';
import 'package:bus_tracker_client/src/track/models/live_tracker/live_track_response_dto.dart';
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
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;

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
  bool _showFinised = false;
  int _lastDestinationIndex = -1;
  int _lastUpdateIndex = -1;
  final Set<Polyline> _polylines = {};
  List<LatLng> latlng = [];
  Map<String, Marker> _markersList = {};
  Uint8List _myIcon;
  Timer _timer;

  BusTrack(this._routeId, this._routeBloc, this._trackBloc,
      this._signalrServices, this._isDriver);

  LatLng get _initialLatLng {
    return LatLng(_routeResponse.places[0].lattitude + 0.002,
        _routeResponse.places[0].longitude + 0.002);
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

  int getNearPointIndex(LatLng currentLatLng) {
    double minDistance = 999;
    int minDistanceIndex = -1;
    for (int i = 0; i < widget.latlng.length; i++) {
      double distance = widget._calculateDistance(currentLatLng,
          LatLng(widget.latlng[i].latitude, widget.latlng[i].longitude));
      if (distance < minDistance) {
        minDistanceIndex = i;
        minDistance = distance;
      }
    }
    return minDistanceIndex;
  }

  void setLastDestinationIndex(PlaceResponse lastPlace) {
    for (int i = 0; i < widget._routeResponse.places.length; i++) {
      if (lastPlace.id == widget._routeResponse.places[i].id) {
        widget._lastDestinationIndex = i;
      }
    }
  }

  void initializeTrackData() async {
    var res = widget._isDriver
        ? await widget._trackBloc
            .getBusRouteByBusId(App.BUS_IDS[widget._routeId])
        : await widget._trackBloc.getBusRouteByUserId(App.user.id);

    onTrackResponseReceived(res);
  }

  void onTrackResponseReceived(BusTrackResponseDto res) {
    setState(() {
      widget._trackData = res;

      if (widget._isDriver) {
        initLocationUpdates();
      } else {
        if (widget._trackData != null && widget._trackData.busId != null) {
          setState(() {
            widget._showNotStarted = false;
            parseTrackData();
          });
        } else {
          widget._showNotStarted = true;
        }
        initSignalRListener();
      }

      if (widget._trackData != null &&
          widget._trackData.busId != null &&
          widget._trackData.lastDestination != null) {
        setLastDestinationIndex(widget._trackData.lastDestination);
        if (widget._lastDestinationIndex ==
            (widget._routeResponse.places.length - 1)) {
          widget._showFinised = true;
          return;
        }
      }
      if (widget._trackData != null &&
          widget._trackData.busId != null &&
          widget._trackData.gDirection != null &&
          widget._trackData.directionResponse != null) {
        setState(() {
          initPolyLines();
          setMarkersList();
        });
      }
      if (widget._trackData != null &&
          widget._trackData.busId != null &&
          widget._trackData.currentLattitude != null &&
          widget._trackData.currentLongitude != null) {
        widget._lastUpdateIndex = getNearPointIndex(LatLng(
            widget._trackData.currentLattitude,
            widget._trackData.currentLongitude));
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
    }
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
    onTrackResponseReceived(response);
//    setState(() {
//      widget._trackData = response;
//      if (widget._trackData != null && widget._trackData.busId != null) {
//        parseTrackData();
//      }
//    });
  }

  void updateToNextPoint() {
    widget._lastUpdateIndex += 5;
    print(widget._lastUpdateIndex);
    print(widget.latlng.length);
    if (widget.latlng.length > widget._lastUpdateIndex) {
      widget._currentLatLng = widget.latlng[widget._lastUpdateIndex];
      print("lat" + widget._currentLatLng.latitude.toString());
      print("lon" + widget._currentLatLng.longitude.toString());
      if (widget._lastDestinationIndex <
          (widget._routeResponse.places.length - 1)) {
        if (widget._lastUpdateIndex >
            getNearPointIndex(LatLng(
                widget._routeResponse.places[widget._lastDestinationIndex + 1]
                    .lattitude,
                widget._routeResponse.places[widget._lastDestinationIndex + 1]
                    .longitude))) {
          updateToNextPlace();
        }
      }
    } else if (widget._lastDestinationIndex <
        (widget._routeResponse.places.length - 1)) {
      updateToNextPlace();
    }
    updateCurrentLocation();
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
    initializeTrackData();
  }

  void updateToNextPlace() async {
    if (widget._routeResponse.places.length >
        (widget._lastDestinationIndex + 1)) {
      widget._currentLatLng = LatLng(
          widget._routeResponse.places[widget._lastDestinationIndex + 1]
              .lattitude,
          widget._routeResponse.places[widget._lastDestinationIndex + 1]
              .longitude);

      updateReachedPlace(
          widget._routeResponse.places[widget._lastDestinationIndex + 1].id);
    }
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
    initializeTrackData();
  }

  void initSignalRListener() {
//    if(!widget._signalrServices.isInitilized) {
      widget._signalrServices.initialize(_handleBroadCastMessage);
      widget._signalrServices.start(App.user.id);
//    }
//    if (widget._timer == null) {
//      const timePeriod = const Duration(seconds: 7);
//      widget._timer =
//          new Timer.periodic(timePeriod, (Timer t) => initializeTrackData());
//    }
  }

  @override
  void dispose() {
    if (widget._timer != null) {
      widget._timer.cancel();
      widget._timer = null;
    }
    if (widget._signalrServices != null) {
      widget._signalrServices.close();
    }
    super.dispose();
  }

  void _handleBroadCastMessage(List<Object> parameters) {
    var map = parameters.first as String;
    LiveTrackResponseDto response =
        LiveTrackResponseDto.fromJson(json.decode(map) as Map<String, dynamic>);
    widget._trackData.lastDestination = response.lastDestination;
    widget._trackData.currentRouteStatus = response.places;
    widget._trackData.currentLattitude =
        response.currentLocationCoordinate.lattitude;
    widget._trackData.currentLongitude =
        response.currentLocationCoordinate.longitude;
    print("live response: ");
    print(response);
    onTrackResponseReceived(widget._trackData);
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
    initBusIcon();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Bus Tracking'),
            bottom: TabBar(
              tabs: [
                Icon(Icons.map),
                Icon(Icons.linear_scale),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MapTrack(
                widget._routeResponse,
                widget._currentLatLng,
                widget._trackData,
                widget._markersList,
                widget._showNotStarted,
                widget._isDriver ? updateToNextPoint : null,
                widget._isDriver ? updateToNextPlace : null,
                widget._polylines,
                widget._showFinised,
              ),
              LineTrack(
                widget._routeResponse,
                widget._currentLatLng,
                widget._trackData,
                widget._etaForPlaces,
                widget._showNotStarted,
                widget._isDriver ? updateToNextPoint : null,
                widget._isDriver ? updateToNextPlace : null,
                widget._showFinised,
                calculateDotPosition(),
              ),
            ],
          ),
        ));
  }

  double calculateDotPosition() {
    double position = 0;
    int srcPointIndex = 0;
    int destPointIndex = 0;
    int currentIndex = 0;
    if (widget._routeResponse == null ||
        widget._routeResponse.places == null ||
        widget._routeResponse.places.length == 0) {
      return position;
    }
    if (widget._lastDestinationIndex <
        widget._routeResponse.places.length - 1) {
      if (widget._lastDestinationIndex != -1) {
        srcPointIndex = getNearPointIndex(LatLng(
            widget
                ._routeResponse.places[widget._lastDestinationIndex].lattitude,
            widget._routeResponse.places[widget._lastDestinationIndex]
                .longitude));
      }
      if (widget._currentLatLng != null) {
        currentIndex = getNearPointIndex(widget._currentLatLng);
      }
      destPointIndex = getNearPointIndex(LatLng(
          widget._routeResponse.places[widget._lastDestinationIndex + 1]
              .lattitude,
          widget._routeResponse.places[widget._lastDestinationIndex + 1]
              .longitude));
      position = (currentIndex - srcPointIndex) /
          (destPointIndex - srcPointIndex) *
          100;
    }
    return position;
  }

  void initBusIcon() async {
    widget._myIcon = await getBytesFromAsset('assets/images/busicon.png', 100);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void setMarkersList() {
    if (widget._markersList.length == 0) {
      Map<String, Marker> list = Map();
      list['current position'] = Marker(
        markerId: MarkerId('current position'),
        position: widget._currentLatLng,
        icon: BitmapDescriptor.fromBytes(widget._myIcon),
        infoWindow: InfoWindow(
          title: 'current position',
          snippet: '-',
        ),
      );

      for (final place in widget._routeResponse.places) {
        String snippet = widget._etaForPlaces.containsKey(place.id)
            ? 'ETA = ' + widget._etaForPlaces[place.id]
            : '-';
        final marker = Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lattitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: snippet,
          ),
        );
        list[place.name] = marker;
      }
      setState(() {
        widget._markersList.clear();
        widget._markersList = list;
      });
    } else {
      setState(() {
        widget._markersList['current position'] = Marker(
          markerId: MarkerId('current position'),
          position: widget._currentLatLng,
          icon: BitmapDescriptor.fromBytes(widget._myIcon),
          infoWindow: InfoWindow(
            title: 'current position',
            snippet: '-',
          ),
        );
        for (final place in widget._routeResponse.places) {
          String snippet = widget._etaForPlaces.containsKey(place.id)
              ? 'ETA = ' + widget._etaForPlaces[place.id]
              : '-';
          final marker = Marker(
            markerId: MarkerId(place.name),
            position: LatLng(place.lattitude, place.longitude),
            infoWindow: InfoWindow(
              title: place.name,
              snippet: snippet,
            ),
          );
          widget._markersList[place.name] = marker;
        }
      });
    }
  }

  void initPolyLines() {
    if (widget.latlng == null ||
        widget._polylines == null ||
        widget.latlng.isEmpty ||
        widget._polylines.isEmpty) {
      widget._polylines.clear();
      var polyLines = decodeEncodedPolyline(widget
          ._trackData.directionResponse.routes.first.overviewPolyline.points);
      for (var poly in polyLines) {
        print(poly);
        widget.latlng.add(poly);
        widget._polylines.add(Polyline(
          polylineId: PolylineId(widget._trackData.busId),
          visible: true,
          points: widget.latlng,
          width: 3,
          color: Colors.black,
        ));
      }
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
}
