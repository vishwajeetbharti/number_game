import 'package:equatable/equatable.dart';
import '../domain/entities.dart';

class GameState extends Equatable {
  final LevelConfig level;
  final int levelIndex;
  final List<Cell> grid;
  final GameStatus status;
  final int timeLeft;
  final int? selectedIndex;
  final int score;
  final int addRowsUsed;

  const GameState({
    required this.level,
    required this.levelIndex,
    required this.grid,
    required this.status,
    required this.timeLeft,
    required this.score,
    this.selectedIndex,
    this.addRowsUsed = 0,
  });

  GameState copyWith({
    LevelConfig? level,
    int? levelIndex,
    List<Cell>? grid,
    GameStatus? status,
    int? timeLeft,
    int? selectedIndex,
    int? score,
    int? addRowsUsed,
  }) {
    return GameState(
      level: level ?? this.level,
      levelIndex: levelIndex ?? this.levelIndex,
      grid: grid ?? this.grid,
      status: status ?? this.status,
      timeLeft: timeLeft ?? this.timeLeft,
      selectedIndex: selectedIndex,
      score: score ?? this.score,
      addRowsUsed: addRowsUsed ?? this.addRowsUsed,
    );
  }

  @override
  List<Object?> get props => [level, levelIndex, grid, status, timeLeft, selectedIndex, score, addRowsUsed];
}
