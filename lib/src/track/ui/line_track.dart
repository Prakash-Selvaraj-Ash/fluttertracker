import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/track/models/bus_track_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './blinking_widget.dart';
import './dot_widget.dart';

class LineTrack extends StatelessWidget {
  final RouteResponse _routeResponse;
  double _blinkingDotPosition = 28;
  bool _blinkingEnabled = false;
  var _trackingText = "Bus Started";
  final LatLng _currentLatLng;
  final BusTrackResponseDto _trackData;
  final Map<String, String> _etaForPlaces;
  final ScrollController _scrollController = ScrollController();
  final bool _showNotStarted;

  LineTrack(this._routeResponse, this._currentLatLng, this._trackData,
      this._etaForPlaces, this._showNotStarted);

  void calculateBlinkingDotPostion() {
    print(_currentLatLng.latitude.toString() +
        " - " +
        _currentLatLng.longitude.toString());
    for (int i = 0; i < _routeResponse.places.length; i++) {
      print(_routeResponse.places[i].lattitude.toString() +
          " - " +
          _routeResponse.places[i].longitude.toString());
      if (_currentLatLng.latitude.toStringAsFixed(4) ==
              _routeResponse.places[i].lattitude.toStringAsFixed(4) &&
          _currentLatLng.longitude.toStringAsFixed(4) ==
              _routeResponse.places[i].longitude.toStringAsFixed(4)) {
        _blinkingDotPosition = (((i + 1) * 100) + 15).toDouble();
      }
      if (_trackData.lastDestination != null &&
          _trackData.lastDestination.id == _routeResponse.places[i].id) {
        if (i == _routeResponse.places.length - 1) {
          _blinkingDotPosition = (((i + 1) * 100) + 15).toDouble();
        } else {
          _blinkingDotPosition = (((i + 1) * 100) + 15).toDouble() + 30;
        }
      }
    }
//    _scrollController.animateTo(_blinkingDotPosition,
//        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLatLng != null && _routeResponse != null) {
      calculateBlinkingDotPostion();
    }
    print(_routeResponse);
    print(_currentLatLng);
    print(_trackData);
    return _showNotStarted
        ? Center(
            child: Text(
              'Bus Not Started',
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
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'eMTe School',
                      style: Theme.of(context)
                          .textTheme
                          .headline.copyWith(fontFamily: 'Precious'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(50, 8, 50, 0),
                                child: Container(
                                  height: 2,
                                  width:
                                      _routeResponse.places.length * 100.0 - 15,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.grey,
                                        child: SizedBox(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Text(
                                          "Started",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...(_routeResponse.places as List)
                                      .map((place) {
                                    print(_etaForPlaces[place.id]);
                                    String text = (place as PlaceResponse).name;
                                    if (_etaForPlaces[place.id] != null) {
                                      text +=
                                          ' ETA : ' + _etaForPlaces[place.id];
                                    } else {
                                      text += ' ETA : - ';
                                    }
                                    return DotWidget(text);
                                  }).toList()
                                ],
                              ),
                              _blinkingEnabled
                                  ? BlinkingDot(_blinkingDotPosition)
                                  : Container(
                                      margin: EdgeInsets.fromLTRB(
                                          _blinkingDotPosition, 0, 0, 0),
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.purple,
                                        child: SizedBox(),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      _trackingText,
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              );
  }
}
