import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './dot_widget.dart';

class LineTrack extends StatelessWidget {
  final RouteResponse _routeResponse;
  double _blinkingDotPosition = 0;
  var _trackingText = "Bus Started";
  final LatLng _currentLatLng;
  final BusTrackResponseDto _trackData;
  final Map<String, String> _etaForPlaces;
  final ScrollController _scrollController = ScrollController();
  final bool _showNotStarted;
  final bool _showFinished;
  final Function _updateToNextPoint;
  final Function _updateToNextPlace;
  final double _calculateDotPostion;

  LineTrack(
      this._routeResponse,
      this._currentLatLng,
      this._trackData,
      this._etaForPlaces,
      this._showNotStarted,
      this._updateToNextPoint,
      this._updateToNextPlace,
      this._showFinished,
      this._calculateDotPostion);

  LatLng get _initialLatLng {
    return LatLng(_routeResponse.places[0].lattitude + 0.002,
        _routeResponse.places[0].longitude + 0.002);
  }

  void calculateBlinkingDotPostion() {
    /*print(_currentLatLng.latitude.toString() +
        " - " +
        _currentLatLng.longitude.toString());*/

    if (_currentLatLng.latitude.toStringAsFixed(4) !=
            _initialLatLng.latitude.toStringAsFixed(4) ||
        _currentLatLng.longitude.toStringAsFixed(4) !=
            _initialLatLng.longitude.toStringAsFixed(4)) {
      _blinkingDotPosition = _calculateDotPostion;
    } else {
      _blinkingDotPosition = 0;
    }

    for (int i = 0; i < _routeResponse.places.length; i++) {
      /* print(_routeResponse.places[i].lattitude.toString() +
          " - " +
          _routeResponse.places[i].longitude.toString());*/
      if (_currentLatLng.latitude.toStringAsFixed(4) ==
              _routeResponse.places[i].lattitude.toStringAsFixed(4) &&
          _currentLatLng.longitude.toStringAsFixed(4) ==
              _routeResponse.places[i].longitude.toStringAsFixed(4)) {
        _blinkingDotPosition = (((i + 1) * 100)).toDouble();
      } else if (_trackData != null &&
          _trackData.lastDestination != null &&
          _trackData.lastDestination.id == _routeResponse.places[i].id) {
        if (i == _routeResponse.places.length - 1) {
          _blinkingDotPosition = (((i + 1) * 100)).toDouble();
        } else {
          _blinkingDotPosition =
              (((i + 1) * 100)).toDouble() + _calculateDotPostion;
        }
      }
    }

    print(_blinkingDotPosition);
//    _scrollController.animateTo(_blinkingDotPosition,
//        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLatLng != null && _routeResponse != null) {
      calculateBlinkingDotPostion();
    }
//    print(_routeResponse);
//    print(_currentLatLng);
//    print(_trackData);

    String text = '';

    if (_showNotStarted) {
      text = 'Bus Not Started';
    }
    if (_showFinished) {
      text = 'Bus Reached Destination';
    }
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
        : _routeResponse == null || _currentLatLng == null || _trackData == null
            ? Center(
                child: CircularProgressIndicator(
                  value: 60,
                ),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _updateToNextPlace == null
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
                                  onPressed: _updateToNextPoint,
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
                                  onPressed: _updateToNextPlace,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  child: Text(
                                    '>>',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
//                        child: Center(
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 1, 10, 0),
                                child: Container(
                                  width: 2,
                                  height:
                                      _routeResponse.places.length * 100.0,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(child: SizedBox()),
                                        CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.grey,
                                            child: SizedBox(),
                                          ),
                                        Expanded(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text(
                                              "Started",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...(_routeResponse.places as List).map((place) {
//                                    print(_etaForPlaces[place.id]);
                                    String text = (place as PlaceResponse).name;
                                    String etaText = '';
                                    if (_etaForPlaces[place.id] != null) {
                                      etaText =
                                          ' ETA : ' + _etaForPlaces[place.id];
                                    }
                                    return DotWidget(text, etaText);
                                  }).toList()
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                    0, _blinkingDotPosition, 0, 0),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Theme.of(context).accentColor,
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                          ],
//                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _trackingText,
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
  }
}
