import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_parking_app/models/geometry.dart';

class Place {
  final String name;
  final double rating;
  final int userRatingCount;
  final String vicinity;
  final Geometry geometry;
  final BitmapDescriptor icon;

  Place(
      {this.name,
      this.rating,
      this.userRatingCount,
      this.vicinity,
      this.icon,
      this.geometry});

  Place.fromJson(Map<dynamic, dynamic> parsedJson, icon)
      : name = parsedJson["name"],
        rating = (parsedJson["rating"]!=null)?parsedJson["rating"].toDouble():null,
        userRatingCount = (parsedJson["user_ratings_total"]!=null)?parsedJson['user_ratings_total']:null,
        vicinity = (parsedJson["vicinity"]!=null)?parsedJson["vicinity"]:null,
        icon = icon,
        geometry = (parsedJson["geometry"]!=null)?Geometry.fromJson(parsedJson["geometry"]):null;

}
