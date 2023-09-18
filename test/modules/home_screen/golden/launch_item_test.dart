import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:space_xxx/modules/home_screen/widget/launch_item.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Launch Item Scenario - Snapshot Test',
      (WidgetTester tester) async {
    await mockNetworkImages(() async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          Device.iphone11,
          Device.phone,
          Device.tabletLandscape,
          Device.tabletPortrait,
        ])
        ..addScenario(
            name: 'Success',
            widget: const LaunchItem(
              index: 1,
              name: 'FalconSat',
              launchedDate: '2006-03-17T00:00:00.000Z',
              success: true,
              image: 'https://images2.imgbox.com/94/f2/NN6Ph45r_o.png',
            ),
            onCreate: (scenarioWidgetKey) async {
              final indexText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('#1'),
              );
              final nameText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('FalconSat'),
              );
              final successText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('Success'),
              );

              final dateText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('March 17, 2006'),
              );

              expect(indexText, findsOneWidget);
              expect(nameText, findsOneWidget);
              expect(successText, findsOneWidget);
              expect(dateText, findsOneWidget);
            })
        ..addScenario(
            name: 'Fail',
            widget: const LaunchItem(
              index: 1,
              name: 'FalconSat',
              launchedDate: '2006-03-17T00:00:00.000Z',
              success: false,
              image: 'https://images2.imgbox.com/94/f2/NN6Ph45r_o.png',
            ),
            onCreate: (scenarioWidgetKey) async {
              final indexText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('#1'),
              );
              final nameText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('FalconSat'),
              );
              final successText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('Fail'),
              );

              final dateText = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.text('March 17, 2006'),
              );

              expect(indexText, findsOneWidget);
              expect(nameText, findsOneWidget);
              expect(successText, findsOneWidget);
              expect(dateText, findsOneWidget);
            });

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'launch_item');
    });
  });
}
