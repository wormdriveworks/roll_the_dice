import 'dart:math';

int calculateRule(String expression) {
  // 주사위 굴리기
  expression = expression.replaceAllMapped(RegExp(r'(\d+d\d+)'), (Match m) {
    return calculateDice(m.group(1)!);
  });

  // 표현식 계산
  return calculateExpression(expression);
}

String calculateDice(String dice) {
  // 주사위 굴리기
  if (dice.contains('d')) {
    List<String> parts = dice.split('d');
    int count = int.parse(parts[0]);
    int sides = int.parse(parts[1]);
    List<int> rolls = List.generate(count, (_) => Random().nextInt(sides) + 1);

    return '${rolls.reduce((a, b) => a + b)}';
  }

  // 주사위 굴리기가 아닌 경우
  return dice;
}

int calculateExpression(String expression) {
  // 괄호 내의 표현을 먼저 계산 후 식을 치환
  while (expression.contains('(')) {
    expression =
        expression.replaceAllMapped(RegExp(r'\(([^()]+)\)'), (Match m) {
      return calculateExpression(m.group(1)!).toString();
    });
  }

  // 곱셈과 나눗셈
  RegExp mulDivRegex =
      RegExp(r'(-?\d+(?:\.\d+)?)\s*([*/])\s*(-?\d+(?:\.\d+)?)');

  while (mulDivRegex.hasMatch(expression)) {
    expression = expression.replaceAllMapped(mulDivRegex, (Match m) {
      double num1 = double.parse(m.group(1)!);
      String op = m.group(2)!;
      double num2 = double.parse(m.group(3)!);
      return op == '*' ? (num1 * num2).toString() : (num1 / num2).toString();
    });
  }

  // 덧셈과 뺄셈
  expression = expression
      .replaceAll(' ', '')
      .replaceAllMapped(RegExp(r'(\+|\-)'), (m) => ' ${m.group(1)} ');

  List<String> parts =
      expression.split(' ').where((part) => part.isNotEmpty).toList();

  double result = double.parse(parts[0]);

  for (int i = 1; i < parts.length; i += 2) {
    String op = parts[i];
    double num = double.parse(parts[i + 1]);

    if (op == '+') {
      result += num;
    } else if (op == '-') {
      result -= num;
    }
  }

  return result.round();
}
