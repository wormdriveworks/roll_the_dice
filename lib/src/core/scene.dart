import '../models/player.dart';

import '../utils/logger.dart';
import '../utils/printDebug.dart';
import '../enums.dart';
import '../typedefs.dart';

class Scene {
  String id;
  SceneType type;
  List<TurnAction> actions;
  BeforeScene? beforeScene;
  AfterScene? afterScene;
  BeforeTurn? beforeTurn;
  AfterTurn? afterTurn;
  Checkmate? checkmate;

  late int _currentTurnIndex;
  late SceneState _sceneState;
  late bool isInitialized = false;

  Scene({
    required board,
    required this.id,
    required this.type,
    required this.actions,
    this.beforeScene,
    this.afterScene,
    this.beforeTurn,
    this.afterTurn,
    this.checkmate,
  });

  SceneState get sceneState => _sceneState;
  int get currentTurnIndex => _currentTurnIndex;

  void init({required int currentTurnIndex}) {
    _currentTurnIndex = currentTurnIndex;

    if (_currentTurnIndex < 0) {
      _sceneState = SceneState.standby;
    } else if (_currentTurnIndex >= actions.length) {
      _sceneState = SceneState.finished;
    } else {
      _sceneState = SceneState.playing;
    }

    isInitialized = true;
  }

  List<Player> start({dynamic board, required List<Player> players}) {
    if (!isInitialized) {
      Log.e('Failed to start scene.', Exception('Scene is not initialized'));
      return [];
    }

    if (_sceneState == SceneState.playing) {
      Log.e('Failed to start scene.', Exception('Scene is already started'));
      return [];
    } else if (_sceneState == SceneState.finished) {
      Log.e('Failed to start scene.', Exception('Scene is already finished'));
      return [];
    }

    if (beforeScene != null) {
      players = beforeScene!(board: board, players: players);
      printDebug('- Before scene processed');
    }

    _sceneState = SceneState.playing;
    _currentTurnIndex = 0;
    printDebug('Start scene', isStart: true);

    return players;
  }

  List<Player> finish({dynamic board, required List<Player> players}) {
    if (!isInitialized) {
      Log.e('Failed to finish scene.', Exception('Scene is not initialized'));
      return [];
    }

    if (_sceneState == SceneState.standby) {
      Log.e('Failed to finish scene.', Exception('Scene is not started yet'));
      return [];
    } else if (_sceneState == SceneState.finished) {
      Log.e('Failed to start scene.', Exception('Scene is already finished'));
      return players;
    }

    printDebug('Finish scene', isEnd: true);

    if (afterScene != null) {
      players = afterScene!(board: board, players: players);
      printDebug('- After scene processed');
    }

    _sceneState = SceneState.finished;

    printDebug('Finish scene', isEnd: true);

    return players;
  }

  Stream<List<Player>> play({dynamic board, required List<Player> players}) async* {
    if (!isInitialized) {
      Log.e('Failed to start turn.', Exception('Scene is not initialized'));
      yield players;
      return;
    }

    printDebug('Start turn $_currentTurnIndex', isStart: true);

    if (_currentTurnIndex >= actions.length) {
      Log.e('Failed to start turn.', Exception('No more actions to process'));
      yield players;
      return;
    }

    if (beforeTurn != null) {
      players = beforeTurn!(
        board: board,
        players: players,
        turnIndex: _currentTurnIndex,
      );

      printDebug('- Before turn processed');
    }

    for (Player player in players) {
      printDebug('- Player ${player.id}, turn index: ${player.nextTurnIndex}');

      if (player.nextTurnIndex == _currentTurnIndex) {
        int actionIndex = 0;

        for (TurnAction action in actions) {
          printDebug('- Action $actionIndex, player action index: ${player.nextActionIndex}');

          if (player.nextActionIndex == actionIndex) {
            players = action(
              board: board,
              players: players,
              currentPlayer: player,
              turnIndex: _currentTurnIndex,
            );
            player.nextActionIndex++;

            printDebug('Action processed');
            printDebug('Player sheet: ${player.sheet}');

            yield players;
          }

          printDebug('- Action Done, player next action index: ${player.nextActionIndex}');

          actionIndex++;
        }

        if (checkmate != null) {
          players = checkmate!(
            board: board,
            players: players,
            currentPlayer: player,
            turnIndex: _currentTurnIndex,
          );

          printDebug('- Checkmate processed');
        }

        player.nextTurnIndex++;
        yield players;
      }
    }

    if (afterTurn != null) {
      players = afterTurn!(
        board: board,
        players: players,
        turnIndex: _currentTurnIndex,
      );

      printDebug('- After turn processed');
    }

    _currentTurnIndex++;

    printDebug('- End turn, Next turn index: $_currentTurnIndex', isEnd: true);

    yield players;
    return;
  }
}
