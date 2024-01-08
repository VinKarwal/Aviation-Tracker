import 'dart:convert';
import 'package:aviation_tracking/api_data/my_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FlightService {
  Future<Set<Marker>> getFlights() async {
    final DateTime now = DateTime.now();

    var url = Uri.parse(
        'http://api.aviationstack.com/v1/flights?access_key=$API_KEY&flight_status=active');
    var response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(6, 6)), 'assets/airplane.png');

    return jsonResponse['data']
        .where((item) => item['live'] != null)
        .map<Marker>((item) {
      print("Coordinates: " +
          item['live']['latitude'].toString() +
          ", " +
          item['live']['longitude'].toString() +
          " at " +
          DateFormat('kk:mm:ss').format(now));
      return Marker(
        markerId: MarkerId(item['flight']['number']),
        icon: customIcon,
        position: LatLng(
          double.parse(item['live']['latitude'].toString()),
          double.parse(item['live']['longitude'].toString()),
        ),
        infoWindow: InfoWindow(
          title: item['flight']['icao'],
          snippet: item['departure']['icao'] + " → " + item['arrival']['icao'],
        ),
      );
    }).toSet();
  }

  Future<Set<Marker>> getAirports() async {
    var url = Uri.parse(
        'http://api.aviationstack.com/v1/airports?access_key=$API_KEY');
    var response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(6, 6)), 'assets/airport.png');

    return jsonResponse['data'].map<Marker>((item) {
      return Marker(
        markerId: MarkerId(item['airport_name']),
        position: LatLng(
          double.parse(item['latitude'].toString()),
          double.parse(item['longitude'].toString()),
        ),
        icon: customIcon,
        infoWindow: InfoWindow(
          title: item['airport_name'],
          snippet: item['country_name'],
        ),
      );
    }).toSet();
  }

  Future<List<Map<String, dynamic>>> getFlightDetails(
      String airline, String flightNumber, String date) async {
    var url = Uri.parse(
        'http://api.aviationstack.com/v1/flights?access_key=$API_KEY&&airline_iata=$airline&flight_iata=$flightNumber');
    var response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
      return List<Map<String, dynamic>>.from(jsonResponse['data']);
    } else {
      throw Exception('Flight not found');
    }
  }
}
