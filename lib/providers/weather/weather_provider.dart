// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'package:open_weather_provider_state/models/custom_error.dart';
import 'package:open_weather_provider_state/models/weather.dart';
import 'package:open_weather_provider_state/repositories/weather_repository.dart';
//import 'package:open_weather_provider_state/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherProvider extends StateNotifier<WeatherState> with LocatorMixin {
  WeatherProvider()
      : super(
          WeatherState.initial(),
        );

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(status: WeatherStatus.loading);

    try {
      final Weather weather = await read<WeatherRepository>().fetchWeather(city);

      state = state.copyWith(
        status: WeatherStatus.loaded,
        weather: weather,
      );
      print('state: $state');
    } on CustomError catch (e) {
      state = state.copyWith(status: WeatherStatus.error, error: e);
      print('state: $state');
    }
  }
}
