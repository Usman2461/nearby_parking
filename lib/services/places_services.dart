import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config_maps.dart';
import '../models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class PlacesService{
  final key = "AIzaSyBkAK5X_mjHfUOw-cvvcccccccccc";


  Future<List<Place>> getPlaces(double lat, double lng) async{
    var response = await http.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$mapKey");
    if(response.statusCode==200){

      var json = convert.jsonDecode(response.body);

      var jsonResults = json["results"] as List;
       BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
      return jsonResults.map((place) => Place.fromJson(place,icon)).toList();
    }
  }
}