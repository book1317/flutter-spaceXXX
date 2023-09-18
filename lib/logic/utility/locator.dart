import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';
import 'package:space_xxx/data/repositories/launchpad_repository.dart';
import 'package:space_xxx/data/repositories/rocket_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );

  locator.registerLazySingleton(() => LaunchRepository());
  locator.registerLazySingleton(() => RocketRepository());
  locator.registerLazySingleton(() => LaunchpadRepository());
}
