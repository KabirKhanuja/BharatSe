import 'package:flutter_test/flutter_test.dart';

import 'package:bharatse/util/wage_floor.dart';

/// The floor is the one claim this app makes out loud, so it is tested here
/// rather than only through the screen that displays it. These constants must
/// stay in step with app/services/pricing/floor.py on the server.
void main() {
  test('floor is materials plus labour plus overhead', () {
    final result = computeFloor(materialCost: 380, hours: 7);

    expect(result.labourCost, 420);
    expect(result.overhead, ((380 + 420) * 0.12).round());
    expect(result.floor, 380 + 420 + result.overhead);
  });

  test('matches the server arithmetic for the demo values', () {
    // The API returns 896 for these inputs. If this drifts, the app and the
    // server will disagree in front of a judge.
    expect(computeFloor(materialCost: 380, hours: 7).floor, 896);
    expect(computeFloor(materialCost: 380, hours: 27).floor, 2240);
  });

  test('more hours always raises the floor', () {
    var previous = 0;
    for (var hours = 1.0; hours <= 40; hours++) {
      final floor = computeFloor(materialCost: 500, hours: hours).floor;
      expect(floor, greaterThan(previous));
      previous = floor;
    }
  });

  test('negative inputs are rejected rather than silently accepted', () {
    expect(() => computeFloor(materialCost: -1, hours: 5), throwsArgumentError);
    expect(() => computeFloor(materialCost: 100, hours: -5), throwsArgumentError);
  });

  test('a price below the floor is lifted to it', () {
    expect(enforceFloor(100, 896), 896);
  });

  test('a price at or above the floor is left alone', () {
    expect(enforceFloor(896, 896), 896);
    expect(enforceFloor(1250, 896), 1250);
  });

  test('zero hours still charges for materials', () {
    final result = computeFloor(materialCost: 500, hours: 0);
    expect(result.labourCost, 0);
    expect(result.floor, greaterThan(500));
  });
}
