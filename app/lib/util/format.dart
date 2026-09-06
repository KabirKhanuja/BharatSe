/// Indian digit grouping: the last three digits, then pairs.
/// 1250 -> 1,250   125000 -> 1,25,000   12500000 -> 1,25,00,000
String inr(int value) {
  final neg = value < 0;
  var s = value.abs().toString();

  if (s.length > 3) {
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    s = '${parts.join(',')},$last3';
  }
  return '${neg ? '-' : ''}₹$s';
}
