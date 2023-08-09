import 'package:ex00/app/domain/models/place.dart';
import 'package:flutter/material.dart';

class WeeklyWeatherPage extends StatelessWidget {
  final Place _place;

  const WeeklyWeatherPage({
    super.key,
    required Place place,
  }) : _place = place;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _getInfoWidgets(_place, context),
        ),
      ),
    );
  }

  List<Widget> _getInfoWidgets(Place place, BuildContext context) {
    List<Widget> list = [];
    list.add(Text(
      _place.name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
    ));
    if (_place.region != null) {
      list.add(Text(
        _place.region!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge,
      ));
    }
    if (_place.country != null) {
      list.add(Text(
        _place.country!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge,
      ));
    }
    for (int i = 1; i <= 7; i++) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
              '${i.toString().padLeft(2, '0')}/${i.toString().padLeft(2, '0')}/23'),
          Text('0${i}C°'),
          Text('${i}0C°'),
          const Text('Sunny'),
        ],
      ));
    }

    return list;
  }
}
