import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graduation_project/location_service.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  TextEditingController _searchcontroller=TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
static final Marker _kGooglePlexMArker=Marker(markerId: MarkerId('_kGooglePlexMArker')
,infoWindow: InfoWindow(title: 'Google plex'),
  icon: BitmapDescriptor.defaultMarkerWithHue(.8),
position: LatLng(37.42796133580664, -122.085749655962),
);
  static final Marker PlexMArker=Marker(markerId: MarkerId('PlexMArker')
    ,infoWindow: InfoWindow(title: 'Google infoplex'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    position: LatLng(37.43296265331129, -122.08832357078792),
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextFormField(
                controller: _searchcontroller,textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText:"search by city"),
                onChanged: (val){print(val);},
              )),
              IconButton(onPressed: ()async{
                var place=await LocationService().getPlace(_searchcontroller.text);
                           _goToPlace(place);
              }, icon: Icon(Icons.search))
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {
                _kGooglePlexMArker,
                PlexMArker
              },

              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }



  Future<void> _goToPlace(Map place) async {
     final double lat=place['geometry']['location']['lat'];
    final double lng=place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat,lng),zoom: 12)
    ));
  }
}