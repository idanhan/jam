import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng? _initialposition;

  @override
  void initState() {
    super.initState();
    getuserpos();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> getuserpos() async {
    try {
      var locationResult = await _location.hasPermission();
      if (locationResult == PermissionStatus.denied) {
        locationResult = await _location.requestPermission();
      }
      if (locationResult == PermissionStatus.granted) {
        LocationData currentLocation = await _location.getLocation();
        print("location");
        setState(() {
          _initialposition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      } else {
        // Handle permission denied scenario
        print('Location permission denied');
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _initialposition == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: height,
              child: Center(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialposition!,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    print("created");
                    setState(() {
                      _mapController = controller;
                    });
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
    );
  }
}
