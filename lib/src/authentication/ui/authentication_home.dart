import 'package:bus_tracker_client/src/route/blocs/route_bloc.dart';
import 'package:bus_tracker_client/src/route/models/map_models/map_route_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';

class AuthenticationHome extends StatefulWidget {
  final RouteBloc _routeBloc;

  AuthenticationHome(this._routeBloc);

  @override
  _AuthenticationHomeState createState() => _AuthenticationHomeState();
}

class _AuthenticationHomeState extends State<AuthenticationHome> {
  @override
  void initState() {
    super.initState();
    initializeRoutes();
  }

  void initializeRoutes() async {
    var routes = await widget._routeBloc.getAllRoutes();
    setState(() {
      App.routeResonse = routes;
    });
  }

  void _changeScreen(BuildContext context, bool isDriver) {
    isDriver
        ? Navigator.pushNamed(context, '/driver')
        : Navigator.pushNamed(context, '/user/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Role'),
      ),
      body: App.routeResonse == null
          ? Center(
              child: CircularProgressIndicator(
                value: 60,
              ),
            )
          : Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        await _changeScreen(context, true);
                      },
                      child: Text(
                        'Driver',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await _changeScreen(context, false);
                      },
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Text(
                        'User',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
