import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/place_response.dart';
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:flutter/material.dart';

typedef PlaceResponseCallback = void Function(
    RouteResponse route, PlaceResponse place);

class RouteSelector extends StatefulWidget {
  final RouteBloc _routeBloc;
  final PlaceResponseCallback onRouteSelected;

  RouteSelector(this._routeBloc, this.onRouteSelected);

  @override
  State<StatefulWidget> createState() {
    return _RouteSelectorState(_routeBloc, onRouteSelected);
  }
}

class _RouteSelectorState extends State {
  final RouteBloc _routeBloc;
  final PlaceResponseCallback _onRouteSelected;

  _RouteSelectorState(this._routeBloc, this._onRouteSelected) {
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
    var routes = await this._routeBloc.getAllRoutes();
    setState(() {
      _routeResponses = routes;
    });
  }

  getRouteDropDown() {
    return _routeResponses.length == 0
        ? Text('No Routes Available')
        : DropdownButton(
            hint: _selectedRoute != null
                ? Text(_selectedRoute.toString())
                : Text('Please select route'),
            onChanged: (RouteResponse selectedValue) {
              setState(() {
                _selectedRoute = selectedValue;
                _placeResponse = null;
                _placeResponses = selectedValue.places;
              });
            },
            items: _routeResponses.map((route) {
              return DropdownMenuItem(
                child: SizedBox(
                  width: 300.0, // for example
                  child: Text(route.toString(), textAlign: TextAlign.left),
                ),
                value: route,
              );
            }).toList());
  }

  getPlaceDropDown() {
    return _placeResponses.length == 0
        ? Text('No Places available')
        : DropdownButton(
            hint: _placeResponse != null
                ? Text(_placeResponse.name)
                : Text('Please select places'),
            onChanged: (PlaceResponse place) {
              _onRouteSelected(_selectedRoute, place);
              setState(() {
                _placeResponse = place;
              });
            },
            items: _placeResponses.map((place) {
              return DropdownMenuItem(
                child: SizedBox(
                  width: 300,
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
        children: <Widget>[getRouteDropDown(), getPlaceDropDown()],
      ),
    );
  }
}
