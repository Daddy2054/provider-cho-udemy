// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_provider/exeptions/weather_exeption.dart';
import 'package:open_weather_provider/models/direct_geocoding.dart';

import '../constants/constants.dart';
import 'http_error_handler.dart';

class WeatherApiServices {
  final http.Client httpClient;
  WeatherApiServices({
    required this.httpClient,
  });

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': kLimit,
        'appid': dotenv.env['APPID'],
      },
    );
    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw WeatherException('Cannot get the location of $city');
      }
      final directGeocoding = DirectGeocoding.fromJson(responseBody);
      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }
}
