import 'package:equatable/equatable.dart';
import 'dart:math';

enum GameStatus { playing, won, lost }

enum CellFeedback { none, valid, invalid }

class LevelConfig extends Equatable {
  final int rows;
  final int cols;
  final int initialFilledRows; // 3-4
  final int maxAddRows;        // limit add-row button usage
  final List<int> allowedNumbers;
  final int seconds;           // 120
  final int difficulty;           // 120

  const LevelConfig({
    required this.rows,
    required this.cols,
    required this.initialFilledRows,
    required this.maxAddRows,
    required this.allowedNumbers,
    required this.seconds,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [rows, cols, initialFilledRows, maxAddRows, allowedNumbers, seconds,difficulty];
}

class Cell extends Equatable {
  final int index;
  final int row;
  final int col;
  final int? value;
  final bool matched;
  final bool selected;
  final CellFeedback feedback;

  const Cell({
    required this.index,
    required this.row,
    required this.col,
    required this.value,
    this.matched = false,
    this.selected = false,
    this.feedback = CellFeedback.none,
  });

  Cell copyWith({
    int? value,
    bool? matched,
    bool? selected,
    CellFeedback? feedback,
  }) {
    return Cell(
      index: index,
      row: row,
      col: col,
      value: value ?? this.value,
      matched: matched ?? this.matched,
      selected: selected ?? this.selected,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [index, row, col, value, matched, selected, feedback];
}

class LevelPresets {
  static final List<LevelConfig> levels = [
    LevelConfig(
      rows: 9, cols: 7, initialFilledRows: 4, maxAddRows: 3,
      allowedNumbers: [1,2,3,4,5,6,7,8,9], seconds: 120,difficulty:1
    ),
    LevelConfig(
      rows: 10, cols: 7, initialFilledRows: 4, maxAddRows: 5,
      allowedNumbers: [0,1,2,3,4,5,6,7,8,9], seconds: 120,difficulty:2
    ),
    LevelConfig(
      rows: 11, cols: 9, initialFilledRows: 4, maxAddRows: 4,
      allowedNumbers: [0,1,2,3,4,5,6,7,8,9], seconds: 120,difficulty:3
    ),
  ];

  static int gridLength(LevelConfig c) => c.rows * c.cols;

  static (int row, int col, int idx) indexTriplet(int index, int cols) {
    final row = index ~/ cols;
    final col = index % cols;
    return (row, col, index);
  }

  static int rcToIndex(int r, int c, int cols) => r * cols + c;

  static int randomAllowed(List<int> allowed, Random rng) => allowed[rng.nextInt(allowed.length)];
}
