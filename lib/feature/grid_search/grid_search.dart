import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_cubit.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_state.dart';
import 'package:taidam_tutor/feature/letter_search/widgets/letter_grid/core/data/models/grid_cell.dart';

class LetterSearchGame extends StatelessWidget {
  final int gridSize;
  final Character targetLetter;
  final List<Character> allowedLetters;

  const LetterSearchGame({
    super.key,
    this.gridSize = 5,
    required this.targetLetter,
    required this.allowedLetters,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LetterSearchCubit()
        ..initializeGrid(
          size: gridSize,
          targetLetter: targetLetter,
          allowedLettersInput: allowedLetters,
        ),
      child: const GridScreen(),
    );
  }
}

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LetterSearchCubit, LetterSearchState>(
          buildWhen: (prev, curr) =>
              prev.targetLetter != curr.targetLetter ||
              prev.isLoading != curr.isLoading,
          builder: (context, state) {
            if (state.isLoading && state.targetLetter == null) {
              return const Text('Letter Search Game');
            }
            return Text(state.targetLetter == null
                ? 'Letter Search Game'
                : 'Find: ${state.targetLetter!.character}');
          },
        ),
      ),
      body: BlocBuilder<LetterSearchCubit, LetterSearchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LetterSearchCubit>().resetGrid();
                      },
                      child: const Text('Try Again / Reset'),
                    )
                  ],
                ),
              ),
            );
          }

          if (state.grid.isEmpty && !state.isLoading) {
            return const Center(
                child: Text(
                    'Grid not initialized. Please ensure parameters are correct and try resetting.'));
          }
          if (state.grid.isEmpty) {
            // Should be caught by above, but as a fallback
            return const Center(child: Text('No grid to display.'));
          }

          double screenWidth = MediaQuery.of(context).size.width;
          double cellSize = (screenWidth * 0.8) / state.gridSize;
          // Ensure minimum cell size for very small screens or large grids
          cellSize = cellSize < 30.0 ? 30.0 : cellSize;
          double fontSize = cellSize * 0.4;

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: state.grid.asMap().entries.map((rowEntry) {
                    int rowIndex = rowEntry.key;
                    List<GridCell> row = rowEntry.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row.asMap().entries.map((cellEntry) {
                        int colIndex = cellEntry.key;
                        GridCell cell = cellEntry.value;
                        Color backgroundColor;
                        if (cell.isTarget && cell.isRevealed) {
                          backgroundColor = Colors.green.shade400;
                        } else {
                          backgroundColor = Colors.blueAccent.shade100;
                        }

                        return GestureDetector(
                          onTap: () {
                            context
                                .read<LetterSearchCubit>()
                                .cellTapped(rowIndex, colIndex);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2.0),
                            width: cellSize,
                            height: cellSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4.0),
                              border:
                                  Border.all(color: Colors.black26, width: 0.5),
                            ),
                            child: Text(
                              cell.letter,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<LetterSearchCubit>().resetGrid();
        },
        tooltip: 'New Grid (Same Settings)',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
