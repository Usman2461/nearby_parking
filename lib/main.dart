import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_parking_app/screens/search.dart';
import 'package:nearby_parking_app/services/geolocator_service.dart';
import 'package:nearby_parking_app/services/places_services.dart';
import 'package:provider/provider.dart';

import 'models/place.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final locatorService = GeoLocatorService();
    final placesService = PlacesService();
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    return MultiProvider(
      providers: [
        FutureProvider(create: (BuildContext context) => locatorService.getLocation()),
        FutureProvider(create: (context) => BitmapDescriptor.fromAssetImage(configuration, "assets/images/parking-icon.png")),
        ProxyProvider <Position, Future<List<Place>>>(
          update: (context, position, places){
            return (position!=null)? placesService.getPlaces(position.latitude, position.longitude):null;
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  SearchScreen(),
      ),
    );
  }
}
