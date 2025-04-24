class Player {
  String id;
  dynamic sheet;

  int nextTurnIndex = 0;
  int nextActionIndex = 0;

  Player({
    required this.id,
    required this.sheet,
  });
}
