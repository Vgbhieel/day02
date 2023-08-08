import 'package:ex00/app/domain/controllers/get_location_controller.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/ui/widget/weather_app_bar.dart';
import 'package:ex00/app/ui/widget/weather_bottom_navigation_bar.dart';
import 'package:ex00/app/ui/widget/weather_category_page.dart';
import 'package:flutter/material.dart';

class WeatherAppPage extends StatefulWidget {
  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {
  late GetLocationController controller;
  String _searchText = '';
  bool _locationError = false;

  @override
  void initState() {
    controller = GetLocationController(
      onLocationGetted: (local) {
        setState(() {
          _searchText = local.latitude.toString();
          _locationError = false;
        });
      },
      onPermissionDenied: () {
        setState(() {
          _locationError = true;
        });
      },
    );
    super.initState();
  }

  void _onSearch(Place result) {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: WeatherAppBar(
              onSearch: _onSearch,
              onGeolocationClicked: () {
                controller.fetchUserLocation();
              },
            ),
          ),
          body: TabBarView(
            children: _getBodyWidgets(_locationError, context),
          ),
          bottomNavigationBar: const WeatherBottomNavigationBar(),
        ));
  }

  List<Widget> _getBodyWidgets(bool isError, BuildContext context) {
    if (isError) {
      return List.generate(3, (index) {
        return Center(
          child: Text(
            "Geolocation is not available, please enable it in your app settings.",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        );
      });
    } else {
      return <Widget>[
        WeatherCategoryPage(
          categoryText: "Currently\n$_searchText",
        ),
        WeatherCategoryPage(
          categoryText: "Today\n$_searchText",
        ),
        WeatherCategoryPage(
          categoryText: "Weekly\n$_searchText",
        ),
      ];
    }
  }
}
