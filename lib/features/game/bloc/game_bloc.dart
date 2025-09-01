import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/number_generator.dart';
import '../domain/entities.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final NumberGenerator _gen = NumberGenerator();
  Timer? _timer;

  GameBloc()
    : super(
        GameState(
          level: LevelPresets.levels.first,
          levelIndex: 0,
          grid: const [],
          status: GameStatus.playing,
          timeLeft: LevelPresets.levels.first.seconds,
          score: 0,
        ),
      ) {
    on<GameStarted>(_onStarted);
    on<CellTapped>(_onCellTapped);
    on<AddRowPressed>(_onAddRow);
    on<TickSecond>(_onTick);
    on<ClearFeedback>(_onClearFeedback);
    on<NextLevelRequested>(_onNextLevel);
    on<RestartLevelRequested>(_onRestartLevel);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TickSecond());
    });
  }

  Future<void> _onStarted(GameStarted e, Emitter<GameState> emit) async {
    final level = LevelPresets.levels[e.levelIndex];
    final grid = _gen.bootstrap(level);
    _timer?.cancel();
    emit(
      GameState(
        level: level,
        levelIndex: e.levelIndex,
        grid: grid,
        status: GameStatus.playing,
        timeLeft: level.seconds,
        score: 0,
        selectedIndex: null,
        addRowsUsed: 0,
      ),
    );
    _startTimer();
  }

  void _onTick(TickSecond e, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;
    final t = state.timeLeft - 1;
    if (t <= 0) {
      _timer?.cancel();
      emit(
        state.copyWith(
          status: GameStatus.lost,
          timeLeft: 0,
          selectedIndex: state.selectedIndex,
        ),
      );
    } else {
      emit(state.copyWith(timeLeft: t, selectedIndex: state.selectedIndex));
    }
  }

  void _onAddRow(AddRowPressed e, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;
    if (state.addRowsUsed >= state.level.maxAddRows) return;

    final nextGrid = _gen.addRow(state.level, state.grid);
    emit(state.copyWith(grid: nextGrid, addRowsUsed: state.addRowsUsed + 1));
    _checkWin(emit); // in case everything becomes matchable
  }

  void _onCellTapped(CellTapped e, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;
    if (e.cellIndex < 0 || e.cellIndex >= state.grid.length) return;

    final cell = state.grid[e.cellIndex];
    if (cell.value == null || cell.matched) return;

    if (state.selectedIndex == null) {
      final updated = List<Cell>.from(state.grid);
      updated[e.cellIndex] = cell.copyWith(selected: true);
      emit(state.copyWith(grid: updated, selectedIndex: e.cellIndex));
      return;
    }

    if (state.selectedIndex == e.cellIndex) {
      final updated = List<Cell>.from(state.grid);
      updated[e.cellIndex] = cell.copyWith(selected: false);
      emit(state.copyWith(grid: updated, selectedIndex: null));
      return;
    }

    final aIdx = state.selectedIndex!;
    final bIdx = e.cellIndex;
    final a = state.grid[aIdx];
    final b = state.grid[bIdx];

    if (a.matched || b.matched || a.value == null || b.value == null) {
      final updated = List<Cell>.from(state.grid);
      updated[aIdx] = a.copyWith(selected: false);
      emit(state.copyWith(grid: updated, selectedIndex: null));
      return;
    }

    final isValid =
        (a.value == b.value) || ((a.value ?? 0) + (b.value ?? 0) == 10);

    if (isValid && _isValidMatch(state.grid, a, b)) {
      final updated = List<Cell>.from(state.grid);
      updated[aIdx] = a.copyWith(
        matched: true,
        selected: false,
        feedback: CellFeedback.valid,
      );
      updated[bIdx] = b.copyWith(
        matched: true,
        selected: false,
        feedback: CellFeedback.valid,
      );

      emit(
        state.copyWith(
          grid: updated,
          selectedIndex: null,
          score: state.score + 1,
        ),
      );

      Future.delayed(const Duration(milliseconds: 260), () {
        add(ClearFeedback([aIdx, bIdx]));
      });

      _checkWin(emit);
    } else {
      final updated = List<Cell>.from(state.grid);
      updated[aIdx] = a.copyWith(
        selected: false,
        feedback: CellFeedback.invalid,
      );
      updated[bIdx] = b.copyWith(
        selected: false,
        feedback: CellFeedback.invalid,
      );
      emit(state.copyWith(grid: updated, selectedIndex: null));

      Future.delayed(const Duration(milliseconds: 240), () {
        add(ClearFeedback([aIdx, bIdx]));
      });
    }
  }

  void _onClearFeedback(ClearFeedback e, Emitter<GameState> emit) {
    final updated = List<Cell>.from(state.grid);
    for (final idx in e.cellIndices) {
      final c = updated[idx];
      updated[idx] = c.copyWith(feedback: CellFeedback.none);
    }
    emit(state.copyWith(grid: updated));
  }

  void _checkWin(Emitter<GameState> emit) {
    final allNonEmpty = state.grid.where((c) => c.value != null);
    final allMatched =
        allNonEmpty.isNotEmpty && allNonEmpty.every((c) => c.matched);
    if (allMatched) {
      _timer?.cancel();
      emit(state.copyWith(status: GameStatus.won, selectedIndex: null));
    }
  }

  void _onNextLevel(NextLevelRequested e, Emitter<GameState> emit) {
    final nextIndex = (state.levelIndex + 1) % LevelPresets.levels.length;
    add(GameStarted(levelIndex: nextIndex));
  }

  void _onRestartLevel(RestartLevelRequested e, Emitter<GameState> emit) {
    add(GameStarted(levelIndex: state.levelIndex));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  _isValidMatch(List<Cell> allCell, Cell a, Cell b) {
    if (a.row == b.row) {
      for (int i = (a.col - b.col).abs() - 1; i > 0; i--) {
        int index = allCell.indexWhere(
          (test) => test.index == max(a.index, b.index) - 1,
        );

        if (!allCell[index].matched) {
          return false;
        }
      }
      return true;
    }
    if (a.col == b.col) {
      for (int i = (a.row - b.row).abs() - 1; i > 0; i--) {
        int index = allCell.indexWhere(
          (test) => test.index == max(a.index, b.index) - (7 * i),
        );

        if (!allCell[index].matched) {
          return false;
        }
      }
      return true;
    }

    if ((a.col - b.col).abs() == (a.row - b.row).abs() &&
        (a.row - b.row).abs() == 1) {
      return true;
    } else if ((a.col - b.col).abs() == (a.row - b.row).abs()) {
      List<int> leftIndex = [];
      List<int> rightIndex = [];
      for (int i = (a.row - b.row).abs() - 1; i > 0; i--) {
        leftIndex.add((max(a.index, b.index) - 6 * i));
        rightIndex.add((max(a.index, b.index) - 8 * i));
      }
      if (leftIndex.contains(a.index) && leftIndex.contains(b.index)) {
        leftIndex.remove(a.index);
        leftIndex.remove(b.index);
        for (var action in leftIndex) {
          int index = allCell.indexWhere((test) => (test.index == action));
          if (!allCell[index].matched) {
            return false;
          }
        }
      }
      if (rightIndex.contains(a.index) && rightIndex.contains(b.index)) {
        rightIndex.remove(a.index);
        rightIndex.remove(b.index);
        for (var action in rightIndex) {
          int index = allCell.indexWhere((test) => (test.index == action));
          if (!allCell[index].matched) {
            return false;
          }
        }
      }
      return true;
    } else {
      int maxInd = a.index > b.index ? a.index : b.index;
      int minInd = a.index < b.index ? a.index : b.index;

      for (int i = maxInd - 1; i > minInd; i--) {
        int index = allCell.indexWhere((test) => (test.index == i));
        if (!allCell[index].matched) {
          return false;
        }
      }
      return true;
    }
  }
}
