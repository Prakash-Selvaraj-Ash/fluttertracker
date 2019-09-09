import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:bus_tracker_client/src/route/ui/route_place_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';

class DriverStartBus extends StatefulWidget {
  final RouteBloc _routeBloc;

  DriverStartBus(this._routeBloc);

  @override
  State<StatefulWidget> createState() {
    return _DriverStartBusState();
  }
}

class _DriverStartBusState extends State<DriverStartBus> {
  PlaceResponse _placeResponse;
  RouteResponse _routeResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Select Your Route')),
        body: Center(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'eMTe School',
                      style: Theme.of(context)
                          .textTheme
                          .headline.copyWith(fontFamily: 'Precious')
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoutePlaceSelector(widget._routeBloc, (route, place) {
                    App.routeId = route.id;
                  },false),
                  SizedBox(
                    height: 70,
                  ),
                  RaisedButton(
                    onPressed: () async {
                     await Navigator.pushNamed(context, '/driver/track',);
                    },
                    child: Text(
                      'Start Bus',
                      style: Theme.of(context).textTheme.button,
                    ),
                  )
                ],
              ),
            )));
  }
}
