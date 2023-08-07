import 'dart:async';
import 'dart:convert';

import 'package:ex00/app/domain/bloc/event/search_place_event.dart';
import 'package:ex00/app/domain/bloc/state/search_place_state.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SearchPlaceBloc extends Bloc<SearchPlaceEvent, SearchPlaceState> {
  SearchPlaceBloc() : super(SearchLoadingState()) {
    on<SearchPlaceWithQuery>(_onSearchPlaceWithQuery);
  }

  Future<void> _onSearchPlaceWithQuery(
    SearchPlaceWithQuery event,
    Emitter<SearchPlaceState> emit,
  ) async {
    emit(SearchLoadingState());
    final queryParameters = {
      'name': event.query,
      'count': '10',
      'language': 'pt',
      'format': 'json',
    };

    var response = await http.get(
      Uri.https('geocoding-api.open-meteo.com', '/v1/search', queryParameters),
    );

    var decodedResponse =
        (jsonDecode(utf8.decode(response.bodyBytes)) as Map)["results"];
    var result = decodedResponse.map((e) {
      String name = e["name"] as String;
      String country = e["country"] as String;
      String? region = e["admin1"] as String?;
      String title;

      if (region != null) {
        title = "$name, $region, $country";
      } else {
        title = name;
      }

      Place place = Place(
        latitude: e["latitude"] as double,
        longitude: e["longitude"] as double,
      );
      return {
        title: place,
      };
    });

    emit(SearchSuccessState(data: result.toList()));
  }
}