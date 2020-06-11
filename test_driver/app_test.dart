// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Conductor App', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Log into conductor mobile", () async{
      
        final emailFieldFinder = find.byValueKey('enter-email');
        final passwordFieldFinder = find.byValueKey('enter-password');
        final submitButtonFinder = find.byValueKey('signin');

        await driver.waitFor(emailFieldFinder);
        await driver.tap(emailFieldFinder);
        await driver.enterText('conductor@domain.com');
        await driver.waitFor(find.text('conductor@domain.com'));

        await driver.waitFor(passwordFieldFinder);
        await driver.tap(passwordFieldFinder);
        await driver.enterText('ha1f3r');
        await driver.waitFor(find.text('ha1f3r'));

        await driver.waitFor(submitButtonFinder);
        await driver.tap(submitButtonFinder);
     

    });

    test("view bus details", () async{
        final  bookingButton = find.byValueKey('booking-button');
        final  refreshButton = find.byValueKey('refresh-button');
        await driver.scrollUntilVisible(
          bookingButton,
          refreshButton,
          dyScroll: -300.0,
        );
        await driver.scrollUntilVisible(
          bookingButton,
          refreshButton,
          dyScroll: 300.0,
        );
        await driver.waitFor(bookingButton);
        await driver.tap(bookingButton);
      
    });

    test("view bookings", () async{
        final  frontContainer = find.byValueKey('front');
        await driver.waitFor(frontContainer);
        
    });

    test("view seats", () async{
        final  seat = find.byValueKey('seat 5');
        await driver.waitFor(seat);
        await driver.tap(seat);
      
    });

    test("view dialog box", () async{
        final  okbutton = find.byValueKey('okButton 5');
        await driver.waitFor(okbutton);
        await driver.tap(okbutton);
      
    });

    test("tap menu button", () async{
        driver.tap(find.byTooltip('Back'));
        final  menubutton = find.byValueKey('menu-button');
        await driver.waitFor(menubutton);
        await driver.tap(menubutton);
    });

    test("tap future trips", () async{
        final  futureTrip = find.byValueKey('popup futureTrips');
        await driver.waitFor(futureTrip);
        await driver.tap(futureTrip);
    });
   
  });
}
