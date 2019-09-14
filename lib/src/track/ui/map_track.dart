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
  Map<String, Marker> _markersList = {};
  final BusTrackResponseDto _trackData;
  final Map<String, String> _etaForPlaces;
  final Set<Polyline> _polylines;
  final bool _showNotStarted;
  final Function _updateToNextPoint;
  final Function _updateToNextPlace;
  final bool _showFinished;

  MapTrack(
      this._routeResponse,
      this._currentLatLng,
      this._trackData,
      this._etaForPlaces,
      this._showNotStarted,
      this._updateToNextPoint,
      this._updateToNextPlace,
      this._polylines,
      this._showFinished);

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
  void setMarkersList() {
    if (widget._markersList.length == 0) {
      Map<String, Marker> list = Map();
      list['current position'] = Marker(
        markerId: MarkerId('current position'),
        position: widget._centeredLatLng,
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
          position: widget._centeredLatLng,
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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setMarkersList();
  }

  @override
  Widget build(BuildContext context) {
    String text = '';
    widget.initBusIcon();

    if (widget._showNotStarted) {
      text = 'Bus Not Started';
    }
    if (widget._showFinished) {
      text = 'Bus Reached Destination';
    }
//    if (widget._routeResponse != null &&
//        widget._currentLatLng != null &&
//        widget._trackData != null) {
//      setMarkersList();
//    }
    return text.isNotEmpty
        ? Center(
            child: Text(
              text,
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
                    widget._updateToNextPlace == null
                        ? Text(
                            'eMTe School',
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(fontFamily: 'Precious'),
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'eMTe School',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(fontFamily: 'Precious'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 60,
                                child: RaisedButton(
                                  onPressed: widget._updateToNextPoint,
                                  child: Text(
                                    '>',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 60,
                                child: RaisedButton(
                                  onPressed: widget._updateToNextPlace,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  child: Text(
                                    '>>',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(
                                            color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
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
