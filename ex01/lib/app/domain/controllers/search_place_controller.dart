import 'dart:async';
import 'dart:convert';
import 'package:ex00/app/domain/models/place.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPlaceController {
  final Function(List<Place>) _onSearchSuccess;
  final Function() _onSearchError;

  SearchPlaceController({
    required Function(List<Place>) onSearchSuccess,
    required Function() onSearchError,
  })  : _onSearchSuccess = onSearchSuccess,
        _onSearchError = onSearchError;

  Future<void> searchPlaceWithQuery(String query) async {
    final queryParameters = {
      'name': query,
      'count': '10',
      'language': 'pt',
      'format': 'json',
    };

    try {
      var response = await http.get(
        Uri.https(
            'geocoding-api.open-meteo.com', '/v1/search', queryParameters),
      );

      var decodedResponse =
          (jsonDecode(utf8.decode(response.bodyBytes)) as Map)["results"];

      List<Place> list = List<Map<String?, dynamic>>.from(decodedResponse)
          .map((e) => _transformJson(e))
          .toList();

      _onSearchSuccess.call(list);
    } catch (e) {
      debugPrint(e.toString());
      _onSearchError.call();
    }
  }

  Place _transformJson(e) {
    String name = e["name"] as String;
    String country = e["country"] as String;
    String? region = e["admin1"] as String?;
    String? regionComplement = e["admin2"] as String?;
    String title;

    if (region != null) {
      title = "$name, ${_getRegionData(region, regionComplement)}, $country";
    } else {
      title = name;
    }

    return Place(
      title: title,
      latitude: e["latitude"] as double,
      longitude: e["longitude"] as double,
    );
  }

  String _getRegionData(String region, String? regionComplement) {
    if (regionComplement != null) {
      return "$region, $regionComplement";
    } else {
      return region;
    }
  }
}
