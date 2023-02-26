import 'package:equatable/equatable.dart';
//import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:open_weather_provider_state/constants/constants.dart';
import 'package:open_weather_provider_state/providers/weather/weather_provider.dart';
//import 'package:provider/provider.dart';
part 'theme_state.dart';

class ThemeProvider extends StateNotifier<ThemeState> with LocatorMixin {
  ThemeProvider() : super(ThemeState.initial());

  void update(Locator watch) {
    final wp = watch<WeatherState>().weather;

    if (wp.temp > kWarmOrNot) {
      state = state.copyWith(appTheme: AppTheme.light);
    } else {
      state = state.copyWith(appTheme: AppTheme.dark);
    }
    super.update(watch);
  }
}
