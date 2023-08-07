import 'dart:async';

import 'package:ex00/app/domain/bloc/event/search_place_event.dart';
import 'package:ex00/app/domain/bloc/search_place_bloc.dart';
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
                  onChanged: (query) => _onSearchChanged(context, query),
                  onSubmitted: (query) => _onSearchChanged(context, query),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.background,
                    enabledBorder: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                    ),
                    hintText: "Search location...",
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
