import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rhino_pizzeria/helpers/functions.dart';
import 'package:rhino_pizzeria/widgets/loading_widget.dart';




class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => MapsScreenState();
}

class MapsScreenState extends State<MapsScreen> {

  bool _loading = false;
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.984261079638824, 35.882439928180496),
    zoom: 14.4746,
  );

  CameraPosition position = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(31.984261079638824, 35.882439928180496),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    myLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              onLongPress:_addMark ,
              initialCameraPosition: _kGooglePlex,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
                markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Visibility(
                visible:_loading ,
                child: const LoadingWidget())
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _setNeLocation,
        label: const Text('Set location'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _setNeLocation() async {

    final Marker? _pos=markers[const MarkerId("location")];
    if(_pos!=null) {
      setState(() {_loading=true;});
      final _lat = _pos.position.latitude;
      final _lon = _pos.position.longitude;
      await updateTruckLocation(_lat, _lon);
      setState(() {_loading=false;});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Truck location updated successfully"),duration: Duration(seconds: 5),));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please pick location by long press on the map firstly"),backgroundColor: Colors.red, duration: Duration(seconds: 5),));
    }
  }



  void myLocation()async{
    Location location =  Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      position=CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(_locationData.latitude??31.984261079638824, _locationData.longitude??35.882439928180496),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414);
    });
  }




  void _addMark(LatLng center) {
    var markerIdVal = "location";
    final MarkerId markerId = MarkerId(markerIdVal);


    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude ,
        center.longitude,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: 'new truck location'),
      onTap: () {
      },
    );

    setState(() {
      markers[markerId] = marker;

    });
  }
}


// _mapTapped(LatLng location) async{
//   print(location);
//   CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: location,
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//   final GoogleMapController controller = await _controller.future;
//   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
// }