import 'package:ex00/app/domain/models/place.dart';

sealed class SearchPlaceState {}

class SearchLoadingState extends SearchPlaceState {}

class SearchSuccessState extends SearchPlaceState {
  List<Map<String, Place>> data;

  SearchSuccessState({required this.data});
}
