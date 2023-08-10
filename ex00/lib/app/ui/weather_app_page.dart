import 'package:ex00/app/domain/bloc/event/weather_app_event.dart';
import 'package:ex00/app/domain/bloc/location_bloc.dart';
import 'package:ex00/app/domain/bloc/state/wheather_app_state.dart';
import 'package:ex00/app/ui/widget/weather_app_bar.dart';
import 'package:ex00/app/ui/widget/weather_bottom_navigation_bar.dart';
import 'package:ex00/app/ui/widget/weather_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherAppPage extends StatefulWidget {
  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {
  void _onSearch(String searchText) {
    // TODO
  }

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(FetchLocation());
  }

  @override
  void dispose() {
    context.read<LocationBloc>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: WeatherAppBar(
            onSearch: _onSearch,
            onGeolocationClicked: () {
              context.read<LocationBloc>().add(FetchLocation());
            },
          ).build(context),
          body: TabBarView(
            children: [
              BlocBuilder<LocationBloc, WeatherAppState>(
                  builder: (context, state) {
                return WeatherCategoryPage(
                  state: state,
                  categoryText: "Currently",
                );
              }),
              BlocBuilder<LocationBloc, WeatherAppState>(
                  builder: (context, state) {
                return WeatherCategoryPage(
                  state: state,
                  categoryText: "Today",
                );
              }),
              BlocBuilder<LocationBloc, WeatherAppState>(
                  builder: (context, state) {
                return WeatherCategoryPage(
                  state: state,
                  categoryText: "Weekly",
                );
              })
            ],
          ),
          bottomNavigationBar: const WeatherBottomNavigationBar(),
        ));
  }
}
