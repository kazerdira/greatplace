import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';

import './mapscreen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  CameraPosition? _position;
  CameraPosition? _currentPosition;
  LatLng? _finalMap;
  late Completer<GoogleMapController> _controller;
  bool _loading = false;

  void errorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('something is going wrong'),
        content: const Text(
            'you have to enable access to the Localisation or your network access'),
        elevation: 15,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("ok"),
          )
        ],
      ),
    );
  }

  Future<void> _getPosition(double lat, double lng) async {
    _controller = Completer();
    final position = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16,
    );
    setState(() {
      _position = position;
      _finalMap = LatLng(lat, lng);
      //print('_getposition latlng is $lat ,$lng');
      _loading = false;
      //  _finalMap = LatLng(lat, lng);
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true;
    });
    try {
      final currentLocationData = await Location().getLocation();
      await _getPosition(
          currentLocationData.latitude!, currentLocationData.longitude!);

      widget.onSelectPlace(
          currentLocationData.latitude!, currentLocationData.longitude!);
    } catch (error) {
      return errorDialog();
    }
  }

  Future<void> _selectOnMap() async {
    setState(() {
      _loading = true;
    });
    try {
      final LatLng selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => MapScreen(
            isSelecting: true,
          ),
        ),
      );

      await _getPosition(selectedLocation.latitude, selectedLocation.longitude);
      widget.onSelectPlace(
          selectedLocation.latitude, selectedLocation.longitude);
    } catch (error) {
      return errorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('test build');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 3,
              color: Colors.grey,
            ),
          ),
          child: _loading == false && _position == null
              ? const Center(
                  child: Text('no map has been choosed yet !'),
                )
              : _loading == true
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ScalingText(
                            'Loading...',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 32.0),
                          const CircularProgressIndicator(),
                        ],
                      ),
                    )
                  : GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _position!,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: _position == null
                          ? {}
                          : {
                              Marker(
                                markerId: const MarkerId('wanted place'),
                                position: _finalMap!,
                              )
                            },
                    ),
        ),
        const SizedBox(
          width: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
