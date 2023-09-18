import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_xxx/constants/api_endpoint.dart';
import 'package:space_xxx/logic/utility/app_bloc_observer.dart';
import 'package:space_xxx/logic/utility/locator.dart';
import 'package:space_xxx/routes.dart';

import 'core/network/mj_network.dart';

void main() {
  const baseURL = BaseURL.dev;

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  final apiClient = createAPIClient(baseURL);

  setupLocator(
    apiClient: apiClient,
  );

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
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent),
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}

MJNetwork createAPIClient(
  String baseURL,
  // List<String> allowedSHAFingerprint,
) {
  final dio = Dio()
    ..options.baseUrl = baseURL
    ..options.connectTimeout = const Duration(milliseconds: 60000)
    ..options.receiveTimeout = const Duration(milliseconds: 60000);

  return MJNetwork(
    dio,
    enableLogging: false,
  );
}
