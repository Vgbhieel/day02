import 'package:bloc/bloc.dart';
import 'package:ex00/app/domain/bloc/event/weather_app_event.dart';
import 'package:ex00/app/domain/bloc/state/wheather_app_state.dart';
import 'package:location/location.dart';

class LocationBloc extends Bloc<WeatherAppEvent, WeatherAppState> {
  LocationBloc() : super(InitialState()) {
    on<FetchLocation>(_onFetchUserLocation);
  }

  Future<void> _onFetchUserLocation(
    WeatherAppEvent event,
    Emitter<WeatherAppState> emit,
  ) async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return emit(PermissionDeniedState());
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return emit(PermissionDeniedState());
      }
    }

    locationData = await location.getLocation();
    emit(LocationGettedState(
        data: "${locationData.latitude} ${locationData.longitude}"));
  }
}
