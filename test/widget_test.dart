import 'package:flutter_test/flutter_test.dart';

import 'package:maestro_booking_demo/main.dart';
import 'package:maestro_booking_demo/models/booking_state.dart';

void main() {
  testWidgets('Home screen shows the package button', (WidgetTester tester) async {
    await tester.pumpWidget(MaestroBookingDemoApp(state: BookingState()));

    expect(find.text('NYC Icons Express'), findsOneWidget);
  });
}
