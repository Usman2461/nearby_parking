import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MarkerService{

  List<Marker> getMarkers(List<Place> places, context, BitmapDescriptor icon) {
    List<Marker> markers = [];

    places.forEach((places) {
      Marker marker = Marker(
          markerId: MarkerId(places.name),
          draggable: false,
          icon: icon ,
          infoWindow: InfoWindow(title: places.name, snippet: places.vicinity),
          position: LatLng(places.geometry.location.lat, places.geometry.location.lng)
      );

      markers.add(marker);
    });
    return markers;
  }
}