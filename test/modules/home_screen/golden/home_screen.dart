import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:space_xxx/constants/sort_order.dart';
import 'package:space_xxx/data/models/launch_model.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';
import 'package:space_xxx/modules/home_screen/bloc/bloc.dart';
import 'package:space_xxx/modules/home_screen/home_screen.dart';

void main() {
  late HomeBloc bloc;
  late LaunchRepository repository;

  setUp(() {
    repository = LaunchRepositoryMock();
    bloc = HomeBloc(repository);

    when(
      () => repository.getlaunchesList(
        const FetchDetail(
          page: 1,
          limit: 10,
          sorter: Sorter(
            key: 'name',
            sortOrder: SorterOrder.none,
          ),
        ),
      ),
    ).thenAnswer(
      (_) => Future.value(
        const LaunchDetail(
          launchs: mockLaunchesList,
          pageDetail: PageDetail(page: 1, totalPages: 10, hasNextPage: true),
        ),
      ),
    );
  });

  tearDown(() {
    bloc.close();
  });

  testGoldens('Home Screen Scenario - Snapshot Test',
      (WidgetTester tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.iphone11,
        // Device.phone,
        // Device.tabletLandscape,
        // Device.tabletPortrait,
      ])
      ..addScenario(
          name: 'Default',
          widget: Builder(builder: (context) {
            // whenListen(
            //   bloc,
            //   Stream.fromIterable(
            //     [
            //       HomeLoadingState(),
            //       HomeLoadedState(),
            //       // HomeErrorState(),
            //     ],
            //   ),
            //   initialState: HomeLoadingState(),
            // );

            return BlocProvider(
              create: (_) => bloc,
              child: const HomeScreen(),
            );
          }),
          onCreate: (scenarioWidgetKey) async {
            final titleText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Launches'),
            );
            // final firstName = find.descendant(
            //   of: find.byKey(scenarioWidgetKey),
            //   matching: find.text('FalconSat'),
            // );

            expect(titleText, findsOneWidget);
            // expect(firstName, findsOneWidget);
          });

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'home_screen', customPump: (widget) {
      return widget.pump(const Duration(seconds: 5));
    });
  });
}

class LaunchRepositoryMock extends Mock implements LaunchRepository {
  // @override
  // Future<LaunchDetail> getlaunchesList(FetchDetail fetchDetail) {
  //   // return Future(() => const LaunchDetail(
  //   //       launchs: mockLaunchesList,
  //   //       pageDetail: PageDetail(page: 1, totalPages: 10, hasNextPage: true),
  //   //     ));
  //   return Future.value(const LaunchDetail(
  //     launchs: mockLaunchesList,
  //     pageDetail: PageDetail(page: 1, totalPages: 10, hasNextPage: true),
  //   ));
  // }
}

const mockLaunchesList = [
  Launch(
      name: 'FalconSat',
      id: '5eb87cd9ffd86e000604b32a',
      image: 'https://images2.imgbox.com/94/f2/NN6Ph45r_o.png',
      launchedDate: '2006-03-17T00:00:00.000Z',
      success: false,
      rocketId: 'rocketId',
      launchpadId: 'launchpadId',
      details:
          'Successful first stage burn and transition to second stage, maximum altitude 289 km, Premature engine shutdown at T+7 min 30 s, Failed to reach orbit, Failed to recover first stage'),
  Launch(
      name: 'FalconSat2',
      id: '5eb87cd9ffd86e000604b32b',
      image: 'https://images2.imgbox.com/94/f2/NN6Ph45r_o.png',
      launchedDate: '2006-03-17T00:00:00.000Z',
      success: false,
      rocketId: 'rocketId',
      launchpadId: 'launchpadId',
      details:
          'Successful first stage burn and transition to second stage, maximum altitude 289 km, Premature engine shutdown at T+7 min 30 s, Failed to reach orbit, Failed to recover first stage'),
];
