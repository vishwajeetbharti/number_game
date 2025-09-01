import 'package:flutter/material.dart';
import '../../domain/entities.dart';

class GameHUD extends StatelessWidget {
  final int levelIndex;
  final int timeLeft;
  final GameStatus status;
  final int score;
  final int addRowsUsed;
  final int maxAddRows;
  final VoidCallback onAddRow;
  final VoidCallback onRestart;
  final VoidCallback onNextLevel;

  const GameHUD({
    super.key,
    required this.levelIndex,
    required this.timeLeft,
    required this.status,
    required this.score,
    required this.addRowsUsed,
    required this.maxAddRows,
    required this.onAddRow,
    required this.onRestart,
    required this.onNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (timeLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeLeft % 60).toString().padLeft(2, '0');
    final statusText = switch (status) {
      GameStatus.playing => 'Playing',
      GameStatus.won => 'Level Complete!',
      GameStatus.lost => 'Time Up!',
    };

    return Card(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text('Level ${levelIndex + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Chip(label: Text('$minutes:$seconds')),
          const SizedBox(width: 5),

          Text('Score: $score'),
          const SizedBox(width: 5),
          FilledButton.tonalIcon(
            onPressed: (status == GameStatus.playing && addRowsUsed < maxAddRows) ? onAddRow : null,
            icon: const Icon(Icons.add),
            label: Text('Row (${maxAddRows - addRowsUsed})'),
          ),
          const SizedBox(width: 8),
          switch (status) {
            GameStatus.playing => OutlinedButton.icon(
                onPressed: onRestart, icon: const Icon(Icons.refresh), label: const Text('Restart')),
            GameStatus.won => FilledButton.icon(
                onPressed: onNextLevel, icon: const Icon(Icons.arrow_forward), label: const Text('Next')),
            GameStatus.lost => FilledButton.icon(
                onPressed: onRestart, icon: const Icon(Icons.replay), label: const Text('Retry')),
          },
        ],
      ),
    );
  }
}
