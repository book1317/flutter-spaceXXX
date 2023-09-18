import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:space_xxx/constants/sort_order.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';
import 'package:space_xxx/modules/home_screen/widget/drawer_sorter.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Drawer Sorter Scenario - Snapshot Test',
      (WidgetTester tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.iphone11,
        Device.phone,
        Device.tabletLandscape,
        Device.tabletPortrait,
      ])
      ..addScenario(
          name: 'Default',
          widget: DrawerSorter(
            sorter: const Sorter(key: 'name', sortOrder: SorterOrder.none),
            onToggleSortOrder: (String mock) {},
          ),
          onCreate: (scenarioWidgetKey) async {
            final titleText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Sort By'),
            );
            final nameSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('None'),
            );
            final launchedDateSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('None'),
            );

            expect(titleText, findsOneWidget);
            expect(nameSorterText, findsWidgets);
            expect(launchedDateSorterText, findsWidgets);
          })
      ..addScenario(
          name: 'Sorter name:asc',
          widget: DrawerSorter(
            sorter: const Sorter(key: 'name', sortOrder: SorterOrder.asc),
            onToggleSortOrder: (String mock) {},
          ),
          onCreate: (scenarioWidgetKey) async {
            final titleText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Sort By'),
            );
            final nameSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Ascending'),
            );
            final launchedDateSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('None'),
            );

            expect(titleText, findsOneWidget);
            expect(nameSorterText, findsOneWidget);
            expect(launchedDateSorterText, findsOneWidget);
          })
      ..addScenario(
          name: 'Sorter name:desc',
          widget: DrawerSorter(
            sorter: const Sorter(key: 'name', sortOrder: SorterOrder.desc),
            onToggleSortOrder: (String mock) {},
          ),
          onCreate: (scenarioWidgetKey) async {
            final titleText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Sort By'),
            );
            final nameSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Descending'),
            );
            final launchedDateSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('None'),
            );

            expect(titleText, findsOneWidget);
            expect(nameSorterText, findsOneWidget);
            expect(launchedDateSorterText, findsOneWidget);
          })
      ..addScenario(
          name: 'Sorter static_fire_date_utc:asc',
          widget: DrawerSorter(
            sorter: const Sorter(
                key: 'static_fire_date_utc', sortOrder: SorterOrder.asc),
            onToggleSortOrder: (String mock) {},
          ),
          onCreate: (scenarioWidgetKey) async {
            final titleText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Sort By'),
            );
            final nameSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('None'),
            );
            final launchedDateSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Ascending'),
            );

            expect(titleText, findsOneWidget);
            expect(nameSorterText, findsOneWidget);
            expect(launchedDateSorterText, findsOneWidget);
          })
      ..addScenario(
          name: 'Sorter static_fire_date_utc:desc',
          widget: DrawerSorter(
            sorter: const Sorter(
                key: 'static_fire_date_utc', sortOrder: SorterOrder.desc),
            onToggleSortOrder: (String mock) {},
          ),
          onCreate: (scenarioWidgetKey) async {
            final titleText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Sort By'),
            );
            final nameSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('None'),
            );
            final launchedDateSorterText = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text('Descending'),
            );

            expect(titleText, findsOneWidget);
            expect(nameSorterText, findsOneWidget);
            expect(launchedDateSorterText, findsOneWidget);
          });

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'drawer_sorter');
  });
}
