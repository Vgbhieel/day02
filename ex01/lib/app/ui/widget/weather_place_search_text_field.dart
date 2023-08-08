import 'dart:async';

import 'package:ex00/app/domain/controllers/search_place_controller.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/ui/widget/weather_place_search_autocomplete.dart';
import 'package:flutter/material.dart';

class WeatherPlaceSearcher extends StatefulWidget {
  final Function(Place suggestion) _onSuggestionSelected;

  const WeatherPlaceSearcher({
    super.key,
    required Function(Place) onSuggestionSelected,
  }) : _onSuggestionSelected = onSuggestionSelected;

  @override
  State<WeatherPlaceSearcher> createState() => _WeatherPlaceSearcherState();
}

class _WeatherPlaceSearcherState extends State<WeatherPlaceSearcher> {
  late final SearchPlaceController controller;
  List<Place> suggestions = List.empty();
  Timer? _debounceTimer;

  @override
  void initState() {
    controller = SearchPlaceController(
      onSearchSuccess: _onSearchSuccess,
      onSearchError: _onSearchError,
    );
    super.initState();
  }

  void _onSearchSuccess(List<Place> result) {
    setState(() {
      suggestions = result;
    });
  }

  void _onSearchError() {
    setState(() {
      suggestions = List.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WeatherPlaceSearchAutocomplete(
        suggestions: suggestions,
        onSearchChanged: _onSearchChanged,
        onSuggestionSelected: widget._onSuggestionSelected);
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      controller.searchPlaceWithQuery(query);
    });
  }
}
