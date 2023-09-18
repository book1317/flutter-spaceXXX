import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_xxx/data/models/launch_model.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';
import 'package:space_xxx/data/repositories/launchpad_repository.dart';
import 'package:space_xxx/data/repositories/rocket_repository.dart';
import 'package:space_xxx/logic/utility/locator.dart';
import 'package:space_xxx/modules/detail_screen/bloc/bloc.dart';
import 'package:space_xxx/modules/detail_screen/detail_screen.dart';
import 'package:space_xxx/modules/home_screen/bloc/bloc.dart';
import 'package:space_xxx/modules/home_screen/home_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => HomeBloc(locator.get<LaunchRepository>()),
              child: const HomeScreen()),
        );
      case RouteNames.detailScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DetailBloc(locator.get<RocketRepository>(),
                locator.get<LaunchpadRepository>()),
            child: DetailScreen(launch: settings.arguments as Launch),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
    }
  }
}

class RouteNames {
  static const homeScreen = '/';
  static const detailScreen = '/detail';
}
