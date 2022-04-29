import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:provider/provider.dart';

class userMapLoc extends StatefulWidget {
  double lat;
  double long;
  String name;
  String phone;

  userMapLoc({this.lat, this.long, this.name, this.phone});

  @override
  State<userMapLoc> createState() => _userMapLocState();
}

class _userMapLocState extends State<userMapLoc> {
  Set<Marker> _marker = {};

  Set<Marker> marker;

  MarkerId selectedMarker;

  bool onMapLoaded = true;

  ImageConfiguration imageConfiguration;

  Set<Circle> _circle = {};

  BitmapDescriptor nearByIcon;

  GoogleMapController _mapController;

  Set<Polyline> _polyline = {};

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Completer<GoogleMapController> _completer = Completer();

  CameraPosition _position =
      CameraPosition(target: LatLng(33.312553, 44.302760), zoom: 14.4746);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        onMapLoaded = false;
        animateTo(widget.lat, widget.long);
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    createMarker();
    updateMarker();
  }

  Future<void> animateTo(double lat, double lng) async {
    final c = await _completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.lat);
    print(widget.long);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Languages.selectedLanguage == 0
              ? "موقع المستخدم على الخريطة"
              : "user location on Map",
          style: Theme.of(context).appBarTheme.textTheme.headline4,
        ),
      ),
      body: onMapLoaded
          ? Center(child: CircularProgressIndicator.adaptive())
          : GoogleMap(
              padding: EdgeInsets.only(bottom: 70),
              initialCameraPosition: _position,
              myLocationButtonEnabled: false,
              indoorViewEnabled: true,
              buildingsEnabled: true,
              // myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              markers: marker,
              circles: _circle,
              polylines: _polyline,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                _completer.complete(controller);
              },
            ),
    );
  }

  _onMapCreated(GoogleMapController controller, Set<Marker> markers) {
    if (mounted) {
      setState(() {
        // _mapController.complete(controller);
        // controller.setMapStyle();
        for (var marker in markers) {
          controller.showMarkerInfoWindow(marker.markerId);
        }
      });
    }
  }

  void createMarker() {
    imageConfiguration =
        createLocalImageConfiguration(context, size: Size(2, 2));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/images/marker.png')
        .then((icon) {
      setState(() {
        nearByIcon = icon;
      });
    });
  }

  double getRandomNumber(int max) {
    var rand = Random();
    int radInt = rand.nextInt(max);
    return radInt.toDouble();
  }

  void updateMarker() {
    LatLng positions;
    Set<Marker> tempMarker = {};
    // Marker f =
    // Marker(markerId: MarkerId('1'),icon: nearByIcon, position:   LatLng(widget.lat, widget.long));
    positions = LatLng(widget.lat, widget.long);
    setState(() {
      tempMarker.add(Marker(
        markerId: MarkerId('driver1'),
        position: positions,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(
            title: widget.name,
            snippet: widget.phone,
            anchor: Offset(0.2, 0.2)),
        rotation: 360,
      ));
    });
    setState(() {
      // marker.add(f);
      marker = tempMarker;
    });
  }
}
