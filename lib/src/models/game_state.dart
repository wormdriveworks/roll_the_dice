class GameState {
  final int createdTimestamp;
  late int updatedTimestamp;
  String currentSceneId;
  int currentTurnIndex;

  GameState({
    required this.createdTimestamp,
    required this.updatedTimestamp,
    required this.currentSceneId,
    required this.currentTurnIndex,
  });

  GameState.initial({
    this.currentSceneId = '',
    this.currentTurnIndex = 0,
  }) : createdTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch {
    updatedTimestamp = createdTimestamp;
  }

  DateTime get createdDate => DateTime.fromMillisecondsSinceEpoch(createdTimestamp).toLocal();

  DateTime get updatedDate => DateTime.fromMillisecondsSinceEpoch(updatedTimestamp).toLocal();

  GameState copyWith({
    String? currentSceneId,
    int? currentTurnIndex,
    DateTime? updatedDate,
  }) {
    return GameState(
      createdTimestamp: createdTimestamp,
      updatedTimestamp: updatedDate != null ? updatedDate.toUtc().millisecondsSinceEpoch : updatedTimestamp,
      currentSceneId: currentSceneId ?? this.currentSceneId,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
    );
  }
}
