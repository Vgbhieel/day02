import 'package:ex00/app/domain/bloc/state/wheather_app_state.dart';
import 'package:flutter/material.dart';

class WeatherCategoryPage extends StatelessWidget {
  const WeatherCategoryPage({
    super.key,
    required String categoryText,
    required WeatherAppState state,
  })  : _categoryText = categoryText,
        _state = state;

  final WeatherAppState _state;
  final String _categoryText;

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case InitialState():
        return Center(
          child: Text(
            _categoryText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        );
      case LocationGettedState():
        {
          return Center(
            child: Text(
              "$_categoryText\n${(_state as LocationGettedState).data}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          );
        }
      case PermissionDeniedState():
        return Center(
          child: Text(
            "Geolocation is not available, please enable it in your app settings.",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        );
    }
  }
}
