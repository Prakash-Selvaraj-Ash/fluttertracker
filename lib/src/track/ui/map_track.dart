import 'dart:async';
import 'dart:typed_data';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapTrack extends StatefulWidget {
  final RouteResponse _routeResponse;
  final LatLng _currentLatLng;
  final Map<String, Marker> _markersList;
  final BusTrackResponseDto _trackData;
//  final Map<String, String> _etaForPlaces;
  final Set<Polyline> _polylines;
  final bool _showNotStarted;
  final Function _updateToNextPoint;
  final Function _updateToNextPlace;
  final bool _showFinished;
  static bool _isMapLoaded = false;

  MapTrack(
      this._routeResponse,
      this._currentLatLng,
      this._trackData,
      this._markersList,
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

  CameraPosition get _kGooglePlex {
    return CameraPosition(
      target: _centeredLatLng,
      zoom: 16,
    );
  }

  @override
  _MapTrackState createState() => _MapTrackState();
}

class _MapTrackState extends State<MapTrack> with AutomaticKeepAliveClientMixin{


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      MapTrack._isMapLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String text = '';

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
              textAlign: TextAlign.center,
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
                                        .copyWith( fontSize: 18),
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
                        markers: MapTrack._isMapLoaded ? widget._markersList.values.toSet() : {},
                        polylines: MapTrack._isMapLoaded ? widget._polylines : {},
                      ),
                    ),
                  ],
                ),
              );
  }
}
