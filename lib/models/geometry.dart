import 'package:nearby_parking_app/models/location.dart';

class Geometry{
  final Location location;
  Geometry({this.location});
  Geometry.fromJson(Map<dynamic, dynamic> parsedJson):location = Location.fromJson(parsedJson['location']);

}