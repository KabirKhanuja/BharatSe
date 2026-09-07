/// The fair wage floor, computed on the phone.
///
/// Mirrors `app/services/pricing/floor.py` on the server. The server is
/// authoritative; this exists so an artisan with no signal still sees a number
/// she can act on rather than a spinner.
///
/// If you change the constants here, change them there too. They are the one
/// piece of arithmetic that has to agree in both places.
const int kFairWagePerHour = 60;
const double kOverheadRate = 0.12;

class WageFloor {
  const WageFloor({
    required this.materialCost,
    required this.labourCost,
    required this.overhead,
    required this.floor,
  });

  final int materialCost;
  final int labourCost;
  final int overhead;
  final int floor;
}

WageFloor computeFloor({
  required int materialCost,
  required double hours,
  int wagePerHour = kFairWagePerHour,
}) {
  if (materialCost < 0) throw ArgumentError('materialCost cannot be negative');
  if (hours < 0) throw ArgumentError('hours cannot be negative');

  final labour = (hours * wagePerHour).round();
  final overhead = ((materialCost + labour) * kOverheadRate).round();

  return WageFloor(
    materialCost: materialCost,
    labourCost: labour,
    overhead: overhead,
    floor: materialCost + labour + overhead,
  );
}

/// The guarantee itself. The market may push a price up. Nothing here can push
/// it below what the maker's own labour is worth.
int enforceFloor(int price, int floor) => price < floor ? floor : price;
