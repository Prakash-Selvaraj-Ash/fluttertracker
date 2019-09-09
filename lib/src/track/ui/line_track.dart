import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './blinking_widget.dart';
import './dot_widget.dart';

class LineTrack extends StatelessWidget {
  final RouteResponse _routeResponse;
  double _blinkingDotPosition = 28;
  bool _blinkingEnabled = false;
  var _trackingText = "Bus Not Started";
  final LatLng _currentLatLng;


  LineTrack(this._routeResponse,this._currentLatLng);

  @override
  Widget build(BuildContext context) {
    return _routeResponse == null
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
                      .headline
                      .copyWith(fontFamily: 'Precious'),
                ),
                SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(50, 8, 50, 0),
                            child: Container(
                              height: 2,
                              width: _routeResponse.places.length * 100.0,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Text(
                                      "Not Started",
                                      style:
                                          Theme.of(context).textTheme.subtitle,
                                    ),
                                  ),
                                ],
                              ),
                              ...(_routeResponse.places as List).map((city) {
                                return DotWidget((city as PlaceResponse).name);
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
                                    backgroundColor: Colors.transparent,
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
