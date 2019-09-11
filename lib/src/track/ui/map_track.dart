import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapTrack extends StatefulWidget {
  final RouteResponse _routeResponse;
  final LatLng _currentLatLng;
  Uint8List _myIcon;
  final Map<String, Marker> _markersList = {};
  final BusTrackResponseDto _trackData;
  final Map<String, String> _etaForPlaces;
  final Set<Polyline> _polylines = {};
  List<LatLng> latlng = [];
  final bool _showNotStarted;

  MapTrack(this._routeResponse, this._currentLatLng, this._trackData,
      this._etaForPlaces, this._showNotStarted);

  LatLng get _centeredLatLng {
    return _routeResponse == null ||
            _routeResponse.places == null ||
            _routeResponse.places.length == 0
        ? LatLng(0, 0)
        : _currentLatLng;
  }

  void initBusIcon() async {
    _myIcon = await getBytesFromAsset('assets/images/busicon.png', 100);
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

  void initPolyLines() {
    _polylines.clear();
    var polyLines = decodeEncodedPolyline(
        _trackData.directionResponse.routes.first.overviewPolyline.points);
    for (var poly in polyLines) {
      print(poly);
      latlng.add(poly);
      _polylines.add(Polyline(
        polylineId: PolylineId(_trackData.busId),
        visible: true,
        points: latlng,
        width: 3,
        color: Colors.black,
      ));
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

  CameraPosition get _kGooglePlex {
    return CameraPosition(
      target: _centeredLatLng,
      zoom: 16,
    );
  }

  @override
  _MapTrackState createState() => _MapTrackState();
}

class _MapTrackState extends State<MapTrack> {
  @override
  void initState() {
    super.initState();
    widget.initBusIcon();
    if(!widget._showNotStarted) {
      widget.initPolyLines();
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      widget._markersList.clear();
      widget._markersList['current position'] = Marker(
        markerId: MarkerId('current position'),
        position: widget._centeredLatLng,
        icon: BitmapDescriptor.fromBytes(widget._myIcon),
        infoWindow: InfoWindow(
          title: 'current position',
          snippet: '-',
        ),
      );

      for (final place in widget._routeResponse.places) {
        final marker = Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lattitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: 'ETA = ' + widget._etaForPlaces[place.id],
          ),
        );
        widget._markersList[place.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget._showNotStarted
        ? Center(
            child: Text(
              'Bus Not Started',
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(fontFamily: 'Quicksand'),
            ),
          )
        : widget._routeResponse == null ||
                widget._currentLatLng == null ||
                widget._trackData == null
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
                        myLocationEnabled: false,
                        initialCameraPosition: widget._kGooglePlex,
                        onMapCreated: _onMapCreated,
                        markers: widget._markersList.values.toSet(),
                        polylines: widget._polylines,
                      ),
                    ),
                  ],
                ),
              );
  }
}
