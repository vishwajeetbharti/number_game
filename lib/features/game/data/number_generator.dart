import 'dart:math';
import '../domain/entities.dart';
import 'levels_data.dart';

class NumberGenerator {
  final Random _rng = Random();

  // List<Cell> bootstrap(LevelConfig level) {
  //   final cells = <Cell>[];
  //   for (int r = 0; r < level.rows; r++) {
  //     for (int c = 0; c < level.cols; c++) {
  //       final idx = r * level.cols + c;
  //       final bool shouldFill = r >= (level.rows - level.initialFilledRows); // fill bottom 3-4 rows only
  //       final int? value = shouldFill ? LevelPresets.randomAllowed(level.allowedNumbers, _rng) : null;
  //       cells.add(Cell(index: idx, row: r, col: c, value: value));
  //     }
  //   }
  //   return cells;
  // }

  List<Cell> bootstrap(LevelConfig level) {
    final cells = <Cell>[];

    final List<int> guaranteedPairs = [];
    if (level.difficulty == 1) {
      return level1;

    } else if (level.difficulty == 2) {
      return level2;

    }

    int gpIndex = 0;

    for (int r = 0; r < level.rows; r++) {
      for (int c = 0; c < level.cols; c++) {
        final idx = r * level.cols + c;
        final bool shouldFill = r >= (level.rows - level.initialFilledRows);

        int? value;
        if (shouldFill) {
          if (gpIndex < guaranteedPairs.length) {
            value = guaranteedPairs[gpIndex++];
          } else {
            value = LevelPresets.randomAllowed(level.allowedNumbers, _rng);
          }
        }
        cells.add(Cell(index: idx, row: r, col: c, value: value));
      }
    }

    return cells;
  }



List<Cell> addRow(LevelConfig level, List<Cell> current) {
    final List<Cell> next = List.from(current);
    int targetRow = -1;
    for (int r = level.rows - 1; r >= 0; r--) {
      final rowValues = next.where((c) => c.row == r).toList();
      final isEmptyRow = rowValues.every((c) => c.value == null);
      if (isEmptyRow) {
        targetRow = r;
        break;
      }
    }
    if (targetRow == -1) {
      for (int r = 0; r < level.rows; r++) {
        final rowValues = next.where((c) => c.row == r).toList();
        final hasNull = rowValues.any((c) => c.value == null);
        if (hasNull) {
          targetRow = r;
          break;
        }
      }
    }
    if (targetRow == -1) {
      return next;
    }


    for (int c = 0; c < level.cols; c++) {
      final idx = targetRow * level.cols + c;
      final old = next[idx];
      next[idx] = old.copyWith(value: LevelPresets.randomAllowed(level.allowedNumbers, _rng), matched: false);
    }
    return next;
  }
}
