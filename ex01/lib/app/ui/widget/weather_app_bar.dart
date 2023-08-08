import 'dart:async';

import 'package:ex00/app/domain/bloc/event/search_place_event.dart';
import 'package:ex00/app/domain/bloc/search_place_bloc.dart';
import 'package:ex00/app/domain/bloc/state/search_place_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherAppBar extends StatelessWidget {
  final Function(String) _onSearch;
  final Function() _onGeolocationClicked;
  Timer? _debounceTimer;

  WeatherAppBar({
    super.key,
    required onSearch,
    required onGeolocationClicked,
  })  : _onSearch = onSearch,
        _onGeolocationClicked = onGeolocationClicked;

  @override
  AppBar build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextEditingController controller = TextEditingController();

    return AppBar(backgroundColor: theme.colorScheme.inversePrimary, actions: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: controller,
                  onChanged: (query) => showSearch(
                    query: query,
                    context: context,
                    delegate: MySearchDelegate(
                        bloc: BlocProvider.of<SearchPlaceBloc>(context),
                        onSearch: (query) {
                          controller.text = query;
                          _onSearchChanged(context, query);
                        }),
                  ),
                  onTap: () => showSearch(
                    context: context,
                    delegate: MySearchDelegate(
                        bloc: BlocProvider.of<SearchPlaceBloc>(context),
                        onSearch: (query) {
                          controller.text = query;
                          _onSearchChanged(context, query);
                        }),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.background,
                    enabledBorder: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                    ),
                    hintText: 'Search location...',
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: Center(
                  child: VerticalDivider(
                    thickness: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(45 / 360),
                  child: IconButton(
                    icon: Icon(Icons.navigation,
                        color: theme.colorScheme.primary),
                    onPressed: _onGeolocationClicked,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  void _onSearchChanged(BuildContext context, String query) {
    _debounceTimer?.cancel();

    // Start a new timer to trigger the search logic after 500 milliseconds of inactivity
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchPlaceBloc>().add(SearchPlaceWithQuery(query: query));
    });
  }
}

class MySearchDelegate extends SearchDelegate {
  final SearchPlaceBloc _bloc;
  final Function(String) _onSearch;

  MySearchDelegate({
    required bloc,
    required onSearch,
  })  : _bloc = bloc,
        _onSearch = onSearch,
        super(
          searchFieldLabel: 'Search location...',
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, null);
          }
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, null);
    _onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onSearch(query);
    return BlocBuilder<SearchPlaceBloc, SearchPlaceState>(
        bloc: _bloc,
        builder: (_, state) {
          switch (state) {
            case SearchLoadingState():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case SearchSuccessState():
              var data = state.data;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index].keys.first),
                      onTap: () {
                        close(context, null);
                        _onSearch(query);
                      },
                    );
                  });
          }
        });
  }
}
