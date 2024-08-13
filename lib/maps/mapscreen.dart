import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/calander/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import './locationmodel.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'dart:ui' as ui;
import './mapeventdatetime.dart';
import './markerdate.dart';
import 'package:intl/intl.dart';
import './eventpage.dart';

class MapScreen extends StatefulWidget {
  List<MapEvent>? mapevents;
  Map<String, Image>? friendsimage;
  Map<String, Image> userimage;
  double height;
  double width;
  MapScreen(
      {super.key,
      this.mapevents,
      this.friendsimage,
      required this.height,
      required this.width,
      required this.userimage});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng? _initialposition;
  Set<Marker> markers = {};
  List<Event> listevents = [];
  late BitmapDescriptor customMarkerIcon;
  List<MapEvent> daymapevents = [];
  List<String> days = List.generate(8, (index) {
    return DateTime.now().add(Duration(days: index)).toIso8601String();
  });

  Map<String, MapEvent> bydayevent = {};
  List<Mapeventdatetime>? dateloc;
  Set<Markerdate> markerdate = {};
  DateTime dateval = DateTime.now();
  late String day;
  final DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  void initState() {
    super.initState();
    getuserpos();
    loadCustomMarker();
    day = days.first;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // void turnmapeventtoevent(List<MapEvent> listmapevents) {
  //    Map<String,Image> selectedfriendimage = {};
  //   if(widget.friendsimage!=null && widget.friendsimage!.isNotEmpty){
  //     selectedfriendimage.addEntries(widget.friendsimage!.entries.where((element) => element.key.compareTo(other) == 0));
  //   }
  //   listevents = listmapevents
  //       .map((e) => Event(
  //           location: e.location,
  //           from: DateTime.parse(e.from),
  //           to: DateTime.parse(e.to),
  //           title: e.eventtitle,
  //           description: e.description,
  //           friendimage:  ))
  //       .toList();
  // }

  Future<void> getuserpos() async {
    try {
      var locationResult = await _location.hasPermission();
      if (locationResult == PermissionStatus.denied) {
        locationResult = await _location.requestPermission();
      }
      if (locationResult == PermissionStatus.granted) {
        LocationData currentLocation = await _location.getLocation();
        setState(() {
          _initialposition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      } else {
        // Handle permission denied scenario
        print('Location permission denied');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> loadCustomMarker() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/band.png', 100);
    customMarkerIcon = BitmapDescriptor.fromBytes(markerIcon);
    // if (widget.mapevents != null) {
    //   for (var element in widget.mapevents!) {
    //     setmarkers(element.location, element.from, element.to, element,widget.height,widget.width);
    //   }
    // }
  }

  Map<String, Image> getfriend(
      Map<String, Image>? mapfriends, List<String>? friendslist) {
    Map<String, Image> friend = {};
    if (friendslist != null && friendslist.isNotEmpty) {
      friendslist.forEach((liste) {
        if (mapfriends != null &&
            mapfriends.isNotEmpty &&
            mapfriends.containsKey(liste)) {
          friend.addEntries(mapfriends.entries
              .where((element) => element.key.compareTo(liste) == 0));
        }
      });
    }

    return friend;
  }

  Future<void> setmarkers(String address, String from, String to,
      MapEvent mapEvent, double height, double width) async {
    if (widget.mapevents != null &&
        widget.mapevents!.isNotEmpty &&
        address.isNotEmpty) {
      try {
        List<geocoding.Location> location =
            await geocoding.locationFromAddress(address);
        LatLng position =
            LatLng(location.first.latitude, location.first.longitude);
        setState(() {
          if (dateloc != null && dateloc!.isNotEmpty) {}
          markers.add(
            Marker(
              markerId: MarkerId(address),
              position: position,
              infoWindow: InfoWindow(title: address),
              icon: customMarkerIcon,
              alpha: 0.7,
              onTap: () {
                Map<String, Image> friends =
                    getfriend(widget.friendsimage, mapEvent.friendsimage);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventViewScreen(
                          event: mapEvent,
                          height: height,
                          width: width,
                          friendimage: friends,
                          userimage: widget.userimage,
                        )));
              },
            ),
          );
          markerdate.add(Markerdate(
              event: mapEvent,
              from: DateTime.parse(from),
              marker: Marker(
                  onTap: () {
                    Map<String, Image> friends =
                        getfriend(widget.friendsimage, mapEvent.friendsimage);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EventViewScreen(
                              event: mapEvent,
                              height: height,
                              width: width,
                              friendimage: friends,
                              userimage: widget.userimage,
                            )));
                  },
                  markerId: MarkerId(address),
                  position: position,
                  infoWindow: InfoWindow(title: address),
                  icon: customMarkerIcon,
                  alpha: 0.7),
              to: DateTime.parse(to)));
          print(markerdate.first.from);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var firstday = days.first;
    final events = Provider.of<EventProvider>(context).evetns;
    return Scaffold(
      body: _initialposition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialposition!,
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  print("created");
                  final Uint8List markerIcon =
                      await getBytesFromAsset('assets/band.png', 200);
                  if (widget.mapevents != null) {
                    widget.mapevents!.addAll(events.map((e) {
                      if (e.friendimage != null) {
                        return MapEvent(
                            from: e.from.toString(),
                            location: e.location,
                            to: e.to.toString(),
                            description: e.description,
                            eventtitle: e.title,
                            friendsimage: e.friendimage!.entries
                                .map((e) => e.toString())
                                .toList());
                      } else {
                        return MapEvent(
                          from: e.from.toString(),
                          location: e.location,
                          to: e.to.toString(),
                          description: e.description,
                          eventtitle: e.title,
                        );
                      }
                    }));
                    widget.mapevents!.forEach((element) {
                      setmarkers(element.location, element.from, element.to,
                          element, height, width);
                    });
                  }
                  setState(() {
                    _mapController = controller;
                  });
                },
                cameraTargetBounds: CameraTargetBounds.unbounded,
                markers: markerdate
                    .where((element) => (((element.from.year == dateval.year) &&
                            (element.from.month == dateval.month) &&
                            (element.from.day == dateval.day)) ||
                        ((element.to.year == dateval.year) &&
                            (element.to.month == dateval.month) &&
                            (element.to.day == dateval.day))))
                    .map((e) => e.marker)
                    .toSet(),

                // onLongPress: (argument) {
                //   final MapEvent mapevent2 = markerdate
                //       .where((element) => ((element.marker.position.latitude ==
                //               argument.latitude) &&
                //           (element.marker.position.longitude ==
                //               argument.longitude)))
                //       .first
                //       .event;
                //   Map<String, Image> friendimage = {};
                //   if (widget.friendsimage != null &&
                //       widget.friendsimage!.isNotEmpty) {
                //         friendimage.addEntries(widget.friendsimage!.entries.where((element) => ));
                //       }
                //   Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => EventViewScreen(
                //           event: mapevent2, height: height, width: width)));
                // },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
              ),
              Positioned(
                top: height * 0.1,
                left: width * 0.32,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: Colors.white,
                  child: DropdownButton<String>(
                      value: day,
                      style: TextStyle(color: Colors.blue),
                      items: days
                          .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                  dateFormat.format(DateTime.parse(value)))))
                          .toList(),
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          day = val!;
                          dateval = DateTime.parse(val);
                        });
                      }),
                ),
              )
            ]),
    );
  }
}
