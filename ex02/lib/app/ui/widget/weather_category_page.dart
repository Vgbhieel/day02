import 'package:flutter/material.dart';

class WeatherCategoryPage extends StatelessWidget {
  final String _categoryText;

  const WeatherCategoryPage({
    super.key,
    required String categoryText,
  }) : _categoryText = categoryText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _categoryText,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}
