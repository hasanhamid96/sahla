import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
class MapScreen extends StatefulWidget {
  Function getLat;

  MapScreen({this.getLat,});

  static var routeName = 'MapScreen';

  //Location location = new Location();
  static Marker thisMarker;
  static bool isMapSelected = false;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myLocation;

  bool isSel;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  GoogleMapController mapController;

  void _add(LatLng position,) {
    MapScreen.isMapSelected = true;
    final String markerIdVal = '0';
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      // onTap: () {
      //   print("markerId");
      //   _onMarkerTapped(markerId);
      // },
      // onDragEnd: (LatLng position) {
      //   _onMarkerDragEnd(markerId, position);
      // },
    );
    setState(() {
      // allpro.changeMapSelectedStatus(true);
      MapScreen.thisMarker = marker;
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                if (myLocation == null) {
                  // widget.getLat(
                  //     thisMarker.position.latitude,
                  //     thisMarker.position.longitude
                  // );
                  UserProvider.latitude = MapScreen.thisMarker.position.latitude;
                  UserProvider.longitude = MapScreen.thisMarker.position.longitude;
                }
                else {
                  // widget.getLat(
                  //     myLocation.latitude,
                  //     myLocation.longitude
                  // );
                  UserProvider.latitude = myLocation.latitude;
                  UserProvider.longitude = myLocation.longitude;
                }
              });
              // setState(() {
              //  print(thisMarker.position.latitude.toString());
              //  print(thisMarker.position.longitude.toString());
              //  print(myLocation.latitude.toString());
              //  print(myLocation.longitude.toString());
              // });
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Text("done",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Stack(
            overflow: Overflow.visible,
            children: [
              GoogleMap(
                // onMapCreated: _onMapCreated,
                // liteModeEnabled: true,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                buildingsEnabled: false,
                // myLocationButtonEnabled: true,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(33.3152, 44.3661),
                  zoom: 10.0,
                ),
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (_controller) async {
                  _completer.complete(_controller);
                  mapController = _controller;
                },
                onTap: (post) {
                  _add(post,);
                },
              ),
              Container(
                margin: EdgeInsets.only(bottom: 80),
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    _determinePosition().catchError((__) {
                      print("NO Location taken");
                    }).then((e) async {
                      if (e != null) {
                        print('eeeeeeeeee $e');
                        setState(() {
                          myLocation = LatLng(
                            e.latitude,
                            e.longitude,
                          );
                        });
                        // print(e.latitude);
                        // print(e.longitude);
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: myLocation, zoom: 13),
                          ),
                        ).then((value) {
                          _add(
                            myLocation,
                          );
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Completer<GoogleMapController> _completer = Completer();

  Future<void> animateTo(double lat, double lng) async {
    final c = await _completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}