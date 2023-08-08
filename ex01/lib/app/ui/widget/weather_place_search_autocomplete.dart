import 'package:ex00/app/domain/models/place.dart';
import 'package:flutter/material.dart';

class WeatherPlaceSearchAutocomplete extends StatelessWidget {
  final List<Place> _suggestions;
  final Function(String query) _onSearchChanged;
  final Function(Place suggestion) _onSuggestionSelected;

  const WeatherPlaceSearchAutocomplete({
    super.key,
    required List<Place> suggestions,
    required Function(String query) onSearchChanged,
    required Function(Place suggestion) onSuggestionSelected,
  })  : _suggestions = suggestions,
        _onSearchChanged = onSearchChanged,
        _onSuggestionSelected = onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Place>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
            enabledBorder: InputBorder.none,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            hintText: 'Search location...',
          ),
        );
      },
      displayStringForOption: (option) => option.title,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable.empty();
        }
        return _suggestions.where((element) => true);
      },
      optionsViewBuilder: (context, onSelected, options) {
        var mOptions = options.toList();
        return Material(
          child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                Place item = mOptions[index];
                return ListTile(
                  title: Text(item.title),
                  onTap: () => onSelected.call(item),
                );
              }),
        );
      },
      onSelected: _onSuggestionSelected,
    );
  }
}
