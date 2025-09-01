import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme.dart';
import '../../bloc/game_bloc.dart';
import '../../bloc/game_event.dart';
import '../../bloc/game_state.dart';
import '../../domain/entities.dart';
import '../widgets/game_hud.dart';
import '../widgets/grid_cell.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Match Puzzle',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => GameBloc()..add(GameStarted(levelIndex: 0)),
        child: Scaffold(
          appBar: AppBar(title: const Text('Number Match')),
          body: SafeArea(
            child: BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                final bloc = context.read<GameBloc>();
                final level = state.level;
                final grid = state.grid;
                log(state.grid.toString());

                return Column(
                  children: [
                    GameHUD(
                      levelIndex: state.levelIndex,
                      timeLeft: state.timeLeft,
                      status: state.status,
                      score: state.score,
                      addRowsUsed: state.addRowsUsed,
                      maxAddRows: state.level.maxAddRows,
                      onAddRow: () => bloc.add(AddRowPressed()),
                      onRestart: () => bloc.add(RestartLevelRequested()),
                      onNextLevel: () => bloc.add(NextLevelRequested()),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cellSize = _computeCellSize(constraints.maxWidth, constraints.maxHeight, level.cols, level.rows);
                          return Center(
                            child: SizedBox(
                              width: cellSize * level.cols,
                              height: cellSize * level.rows,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: level.cols,
                                  childAspectRatio: 1,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                ),
                                itemCount: grid.length,
                                itemBuilder: (context, i) {
                                  return GridCellWidget(
                                    cell: grid[i],
                                    onTap: () {

                                      bloc.add(CellTapped(i,state.selectedIndex));
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _computeCellSize(double maxW, double maxH, int cols, int rows) {
    final wCell = (maxW - 16) / cols;
    final hCell = (maxH - 120) / rows;
    return wCell < hCell ? wCell : hCell;
  }
}
