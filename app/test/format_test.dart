import 'package:flutter_test/flutter_test.dart';
import 'package:bharatse/util/format.dart';

void main() {
  test('groups rupees the Indian way, not the western way', () {
    expect(inr(0), '₹0');
    expect(inr(999), '₹999');
    expect(inr(1250), '₹1,250');
    expect(inr(12500), '₹12,500');
    expect(inr(125000), '₹1,25,000');
    expect(inr(1250000), '₹12,50,000');
    expect(inr(12500000), '₹1,25,00,000');
  });

  test('handles negatives without mangling the symbol', () {
    expect(inr(-1250), '-₹1,250');
  });
}
