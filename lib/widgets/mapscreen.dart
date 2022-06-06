import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocalisation;
  final bool isSelecting;
  MapScreen(
      {this.initialLocalisation =
          const PlaceLocation(latitude: 36.631, longitude: 5.246),
      this.isSelecting = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controller = Completer();
  LatLng? _pickedLocation;

  void _selectedLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.red,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedLocation);
                      },
                icon: const Icon(Icons.check))
        ],
        //title: const Text('Select in the map '),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocalisation.latitude,
              widget.initialLocalisation.longitude),
          zoom: 16,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: widget.isSelecting ? _selectedLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('wanted place'),
                  position: _pickedLocation ??
                      LatLng(widget.initialLocalisation.latitude,
                          widget.initialLocalisation.longitude),
                )
              },
      ),
    );
  }
}
