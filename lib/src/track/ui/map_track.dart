import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bus_tracker_client/src/route/models/route_response.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;


class MapTrack extends StatefulWidget {
  final RouteResponse _routeResponse;
  final LatLng _currentLatLng;
  Uint8List _myIcon;
  final Map<String, Marker> _markersList = {};

  MapTrack(this._routeResponse,this._currentLatLng);

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
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
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
          snippet: '0 min',
        ),
      );

      for (final place in widget._routeResponse.places) {
        final marker = Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lattitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: 'ETA = 10 min',
          ),
        );
        widget._markersList[place.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget._routeResponse == null
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
                  ),
                ),
              ],
            ),
          );
  }
}
