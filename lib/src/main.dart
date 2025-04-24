import 'models/player.dart';
import 'models/game_state.dart';
import 'core/options.dart';
import 'core/scene.dart';

import 'utils/logger.dart';
import 'enums.dart';

class RollTheDice {
  final Options options;
  dynamic board;
  GameState gameState;
  List<Scene> scenes;
  List<Player> players;

  late Scene _currentScene;

  RollTheDice({
    required this.options,
    this.board,
    required this.gameState,
    required this.scenes,
    required this.players,
  }) {
    if (gameState.currentSceneId != '') {
      try {
        _currentScene = scenes.firstWhere((sceneItem) => sceneItem.id == gameState.currentSceneId);
      } catch (_) {
        _currentScene = scenes.first;
        gameState.currentSceneId = _currentScene.id;
      }
    } else {
      _currentScene = scenes.first;
      gameState.currentSceneId = _currentScene.id;
    }
  }

  Stream<({GameState game, List<Player> players})> start() async* {
    if (scenes.isEmpty) {
      Log.e('Failed to start game.', Exception('No scenes to start'));
      yield* Stream.empty();
      return;
    }

    Log.i('Game started, Scene: ${_currentScene.id}');

    _currentScene.init(currentTurnIndex: gameState.currentTurnIndex);

    if (_currentScene.sceneState == SceneState.standby) {
      yield (game: gameState, players: _currentScene.start(board: board, players: players));
    } else if (_currentScene.sceneState == SceneState.finished) {
      yield (game: gameState, players: players);
    }

    await for (final newPlayers in _currentScene.play(board: board, players: players)) {
      yield (
        game: gameState.copyWith(
          currentSceneId: _currentScene.id,
          currentTurnIndex: _currentScene.currentTurnIndex,
          updatedDate: DateTime.now(),
        ),
        players: newPlayers,
      );
    }
  }

  void end() {
    Log.i('game ended');
  }

  void save() {
    Log.i('Game saved');
  }

  void load() {
    Log.i('Game loaded');
  }
}
