import 'dart:math';
import '../typedefs.dart';

class Dice {
  final Random _random = Random();
  int sides;
  int count;

  factory Dice(String name) {
    final List<String> parts = name.split('d');
    assert(parts.length == 2, 'Invalid dice format. Use "XdY" format.');

    final int sides = int.parse(parts[1]);
    final int count = int.parse(parts[0]);

    return (sides > 0 && count > 0)
        ? Dice._internal(
            sides: sides,
            count: count,
          )
        : throw ArgumentError('Invalid dice format. Use "XdY" format.');
  }

  Dice._internal({
    required this.sides,
    required this.count,
  })  : assert(sides > 0, 'Number of sides must be greater than 0'),
        assert(count > 0, 'Number of dice must be greater than 0');

  RolledDice roll() {
    final List<int> results = [];
    int total = 0;

    for (int i = 0; i < count; i++) {
      final int result = _random.nextInt(sides) + 1;
      results.add(result);
      total += result;
    }

    return (results, total);
  }

  @override
  String toString() {
    return 'Dice ${count}D$sides';
  }
}
