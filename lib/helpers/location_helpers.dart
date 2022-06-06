import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

String GOOGLE_API_KEY = 'AIzaSyCvx8nuGRNvO3n4l21WFJ9X-kraru7_rOk';

Future<String> getPlace(double lat, double lng) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY');

  final response = await http.get(url);
  return json.decode(response.body)["results"][4]["formatted_address"];
}

//&signature=YOUR_SIGNATURE