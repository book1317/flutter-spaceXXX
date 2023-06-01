import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaceXXX/logic/utility/app_bloc_observer.dart';
import 'package:spaceXXX/routes.dart';

void main() {
  Bloc.observer = AppBlocObserver();

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF000000)),
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}
