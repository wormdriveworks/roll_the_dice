import './models/player.dart';
import './core/scene.dart';

typedef Board = ({
  String id,
  String title,
  dynamic boardSheet,
});

typedef BeforeScene = List<Player> Function({
  Board? board,
  List<Player> players,
});
typedef AfterScene = List<Player> Function({
  Board? board,
  List<Player> players,
});
typedef BeforeTurn = List<Player> Function({
  Board? board,
  List<Player> players,
  int turnIndex,
});
typedef AfterTurn = List<Player> Function({
  Board? board,
  List<Player> players,
  int turnIndex,
});
typedef TurnAction = List<Player> Function({
  Board? board,
  List<Player> players,
  Player currentPlayer,
  int turnIndex,
});
typedef Checkmate = List<Player> Function({
  Board? board,
  List<Player> players,
  Player currentPlayer,
  int turnIndex,
});

typedef RolledDice = (List<int> results, int total);
