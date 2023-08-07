sealed class WeatherAppState {}

class LocationGettedState extends WeatherAppState {
  final String data;

  LocationGettedState({required this.data});
}

class InitialState extends WeatherAppState {}

class PermissionDeniedState extends WeatherAppState {}
