import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaceXXX/data/models/launch_model.dart';
import 'package:spaceXXX/data/repositories/launch_repository.dart';
import 'package:spaceXXX/data/repositories/launchpad_repository.dart';
import 'package:spaceXXX/data/repositories/rocket_repository.dart';
import 'package:spaceXXX/modules/detail_screen/bloc/bloc.dart';
import 'package:spaceXXX/modules/detail_screen/detail_screen.dart';
import 'package:spaceXXX/modules/home_screen/bloc/bloc.dart';
import 'package:spaceXXX/modules/home_screen/home_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => HomeBloc(LaunchRepository()),
              child: const HomeScreen(
                title: "Launches",
              )),
        );
      case RouteNames.detailScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                DetailBloc(RocketRepository(), LaunchpadRepository()),
            child: DetailScreen(launch: settings.arguments as Launch),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            title: "Home Screen Default",
          ),
        );
    }
  }

  //   Route onGenerateRoute(RouteSettings settings) {
  //   final route = Routes.routes[settings.name];
  //   if (route == null) {
  //     throw Exception('unknown route is called!');
  //   }

  //   return route;
  // }
}

// class Routes {
//   static Map<String, Route> routes = <String, Route>{
//     RouteNames.homeScreen: MaterialPageRoute(
//       builder: (_) => const HomeScreen(
//         title: "Launches",
//       ),
//     ),
//     RouteNames.detailScreen: MaterialPageRoute(
//       builder: (_) => const HomeScreen(
//         title: "Launches 2",
//       ),
//     )
//   };
// }

class RouteNames {
  static const homeScreen = '/';
  static const detailScreen = '/detail';
}
