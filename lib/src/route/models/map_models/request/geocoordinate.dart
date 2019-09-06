class GeoCordinate {

  GeoCordinate({this.lat, this.long});

  double lat;
  double long;

  @override
  String toString() {
    return '${lat},${long}';
  }
}
