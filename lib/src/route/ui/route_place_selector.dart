import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';

typedef PlaceResponseCallback = void Function(
    RouteResponse route, PlaceResponse place);

class RoutePlaceSelector extends StatefulWidget {
  final RouteBloc _routeBloc;
  final PlaceResponseCallback _onRouteSelected;
  final bool _placeSelectionNeeded;

  RoutePlaceSelector(
      this._routeBloc, this._onRouteSelected, this._placeSelectionNeeded);

  @override
  State<StatefulWidget> createState() {
    return _RoutePlaceSelectorState();
  }
}

class _RoutePlaceSelectorState extends State<RoutePlaceSelector> {
  _RoutePlaceSelectorState() {
    this._routeResponses = List<RouteResponse>();
    this._placeResponses = List<PlaceResponse>();
  }

  List<RouteResponse> _routeResponses;
  List<PlaceResponse> _placeResponses;
  RouteResponse _selectedRoute;
  PlaceResponse _placeResponse;

  @override
  void initState() {
    super.initState();
    initializeRoutes();
  }

  void initializeRoutes() async {
    var routes;

    if (App.routeResonse == null) {
      routes = await widget._routeBloc.getAllRoutes();
      App.routeResonse = routes;
    } else {
      routes = App.routeResonse;
    }

    setState(() {
      _routeResponses = routes;
    });
  }

  getRouteDropDown() {
    return _routeResponses.length == 0
        ? Text('No Routes Available')
        : Container(
            width: 300,
            child: FittedBox(
              child: DropdownButton(
                  hint: _selectedRoute != null
                      ? Text(_selectedRoute.toString())
                      : Text('Please select route'),
                  onChanged: (RouteResponse selectedValue) {
                    setState(() {
                      _selectedRoute = selectedValue;
                      App.routeId = selectedValue.id;
                      _placeResponse = null;
                      _placeResponses = selectedValue.places;
                    });
                  },
                  items: _routeResponses.map((route) {
                    return DropdownMenuItem(
                      child: Text(route.toString(), textAlign: TextAlign.left),
                      value: route,
                    );
                  }).toList()),
            ),
          );
  }

  getPlaceDropDown() {
    return _placeResponses.length == 0
        ? Text('No Places available')
        : DropdownButton(
            hint: _placeResponse != null
                ? Text(_placeResponse.name)
                : Text('Please select places'),
            onChanged: (PlaceResponse place) {
              widget._onRouteSelected(_selectedRoute, place);
              setState(() {
                _placeResponse = place;
              });
            },
            items: _placeResponses.map((place) {
              return DropdownMenuItem(
                child: SizedBox(
                  width: 280,
                  child: Text(place.name, textAlign: TextAlign.left),
                ),
                value: place,
              );
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          getRouteDropDown(),
          SizedBox(
            height: 20,
          ),
          widget._placeSelectionNeeded ? getPlaceDropDown() : SizedBox()
        ],
      ),
    );
  }
}
