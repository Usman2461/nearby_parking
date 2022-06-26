import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_parking_app/services/geolocator_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/place.dart';
import '../services/markers_service.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key key}) : super(key: key);

  GeoLocatorService _geoLocatorService = GeoLocatorService();

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final icon = Provider.of<BitmapDescriptor>(context);
    final markerService = MarkerService();
    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        body: (currentPosition != null && icon!=null)
            ? SafeArea(
                child: Consumer<List<Place>>(builder: (context, places, _) {
                  List<Marker> markers = (places!=null) ? markerService.getMarkers(places, context, icon): [];
                  if(places!=null)
                  return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentPosition.longitude,
                                  currentPosition.latitude),
                              zoom: 16.0),
                          zoomGesturesEnabled: true,
                          markers: Set<Marker>.of(markers),
                          onMapCreated: (controller){

                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                         places != null
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    (places.isNotEmpty) ? places.length : 0,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                      future: _geoLocatorService.getDistance(
                                          currentPosition.latitude,
                                          currentPosition.longitude,
                                          places[index].geometry.location.lat,
                                          places[index].geometry.location.lng),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData)
                                          return Card(
                                              child: ListTile(
                                            title: Text(places[index].name),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RatingBarIndicator(
                                                    itemBuilder: (context,
                                                            index) =>
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                  rating: places[index].rating??0,
                                                  itemSize: 14.0,
                                                ),
                                                Text(
                                                    "${places[index].vicinity} : ${(snapshot.data).round()} km"),
                                              ],
                                            ),
                                                trailing: GestureDetector(
                                                    onTap: (){
                                                      _launchMapsUrl(places[index].geometry.location.lat,places[index].geometry.location.lng );
                                                    },
                                                    child: Icon(Icons.directions, color: Colors.blue,)),
                                          ));
                                        return Card(
                                            child: ListTile(
                                          title: Text(places[index].name),
                                        ));
                                      });
                                })
                            : Center(child: Text("Loading Data...."))

                    ],
                  ),
                );
                  else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async{
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw "Could not launch $url";
    }
  }
}
