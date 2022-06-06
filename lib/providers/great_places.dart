import 'dart:io';

import 'package:flutter/material.dart';

import '../model/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helpers.dart';

class greatPlaces with ChangeNotifier {
  List<Place> _item = [];
  List<Place> get item {
    return _item;
  }

  Place findById(String id) {
    return _item.firstWhere((item) => item.id == id);
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation pickedLoaction) async {
    final adress =
        await getPlace(pickedLoaction.latitude, pickedLoaction.longitude);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: PlaceLocation(
            adress: adress,
            latitude: pickedLoaction.latitude,
            longitude: pickedLoaction.longitude),
        image: image);
    _item.add(newPlace);
    notifyListeners();
    DBhelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'adress': newPlace.location.adress!,
    });
  }

  Future<void> setAndFetchPlaces() async {
    final dataList = await DBhelper.getData('user_places');
    _item = dataList
        .map((item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(
                adress: item['adress'],
                latitude: item['loc_lat'],
                longitude: item['loc_lng']),
            image: File(item['image'])))
        .toList();
    notifyListeners();
  }

  Future<void> deletePlace(String id) async {
    await DBhelper.DeleteData('user_places', id);

    notifyListeners();
  }
}
