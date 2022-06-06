// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/location_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/image_input.dart';
import '../providers/great_places.dart';
import '../model/place.dart';

class PlaceAddScreen extends StatefulWidget {
  static const routeName = 'add-place';

  const PlaceAddScreen({Key? key}) : super(key: key);

  @override
  State<PlaceAddScreen> createState() => _PlaceAddScreenState();
}

class _PlaceAddScreenState extends State<PlaceAddScreen> {
  final _titlecontroller = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  missingDataDialog(String missing) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('No $missing is entred'),
        content: Text('you have to enter the $missing '),
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

  savePlace() {
    if (_titlecontroller.text.isEmpty) {
      return missingDataDialog('title');
    }
    if (_pickedImage == null) {
      return missingDataDialog('image');
    }
    if (_pickedLocation == null) {
      return missingDataDialog('map');
    } else {
      Provider.of<greatPlaces>(context, listen: false)
          .addPlace(_titlecontroller.text, _pickedImage!, _pickedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'title'),
                    controller: _titlecontroller,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage),
                  const SizedBox(height: 10),
                  LocationInput(_selectPlace),
                ],
              ),
            ),
          ),
        ),
        RaisedButton.icon(
          onPressed: savePlace,
          icon: const Icon(Icons.add),
          label: const Text('Add a Place'),
          elevation: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: Theme.of(context).accentColor,
        ),
      ]),
    );
  }
}
