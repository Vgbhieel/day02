sealed class SearchPlaceEvent {}

class SearchPlaceWithQuery extends SearchPlaceEvent {
  final String query;

  SearchPlaceWithQuery({required this.query});
}
