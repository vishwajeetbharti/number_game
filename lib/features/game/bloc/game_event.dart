import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  final int levelIndex;
  GameStarted({required this.levelIndex});
  @override
  List<Object?> get props => [levelIndex];
}

class CellTapped extends GameEvent {
  final int cellIndex;
  final int? selectedIndex;
  CellTapped(this.cellIndex,this.selectedIndex);
  @override
  List<Object?> get props => [cellIndex];
}

class AddRowPressed extends GameEvent {}

class TickSecond extends GameEvent {}

class ClearFeedback extends GameEvent {
  final List<int> cellIndices;
  ClearFeedback(this.cellIndices);
  @override
  List<Object?> get props => [cellIndices];
}

class NextLevelRequested extends GameEvent {}
class RestartLevelRequested extends GameEvent {}
