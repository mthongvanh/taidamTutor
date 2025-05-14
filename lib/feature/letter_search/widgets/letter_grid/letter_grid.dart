import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_cubit.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_state.dart';
import 'package:taidam_tutor/feature/letter_search/widgets/letter_grid/core/data/models/grid_cell.dart';

class LetterGrid extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const LetterGrid(
    this.audioPlayer, {
    super.key,
  });

  void _showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Congratulations!',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/png/celebrate.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const Text(
                'You found them all!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Reset the grid by calling the cubit method
                context.read<LetterSearchCubit>().resetGrid();
              },
            ),
          ],
        );
      },
    );
  }

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
              return const Text('Character Search Game');
            }
            return Text(
              state.targetLetter == null
                  ? 'Character Search Game'
                  : state.searchMode == SearchMode.singleCharacter
                      ? 'Find'
                      : 'Find words containing',
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () {
              context.read<LetterSearchCubit>().changeSearchMode();
            },
          ),
        ],
      ),
      body: BlocListener<LetterSearchCubit, LetterSearchState>(
        listener: (context, state) {
          // Assuming your LetterSearchState has a 'gameWon' boolean property
          // You'll need to add this property to your LetterSearchState
          // and update it in your LetterSearchCubit when all letters are found.
          if (state.gameWon) {
            // Replace 'gameWon' with your actual property name
            _showWinDialog(context);
          }
        },
        child: BlocBuilder<LetterSearchCubit, LetterSearchState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return _LetterSearchError(state.errorMessage!);
            }

            if (state.grid.isEmpty && !state.isLoading) {
              return _LetterSearchError(
                'Grid not initialized. Please ensure parameters are correct and try resetting.',
              );
            }

            if (state.grid.isEmpty) {
              // Should be caught by above, but as a fallback
              return _LetterSearchError('No grid to display.');
            }

            double screenWidth = MediaQuery.of(context).size.width;
            double cellSize = (screenWidth * 0.8) / state.gridSize;
            // Ensure minimum cell size for very small screens or large grids
            cellSize = cellSize < 30.0 ? 30.0 : cellSize;
            double fontSize = cellSize * 0.25;

            return Column(
              spacing: 16,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: cellSize * 1.5,
                        height: cellSize * 1.5,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.loose,
                          children: [
                            Text(
                              state.targetLetter?.character ?? '',
                              style: const TextStyle(
                                fontSize: 70,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.play_circle),
                                onPressed: () {
                                  if (state.targetLetter?.audio != null) {
                                    audioPlayer.play(
                                      AssetSource(
                                        'audio/${state.targetLetter?.audio}.caf',
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'sounds like \'${state.targetLetter?.sound ?? ''}\'',
                        style: const TextStyle(
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
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

                              return _SearchGridItem(
                                rowIndex: rowIndex,
                                colIndex: colIndex,
                                cellSize: cellSize,
                                backgroundColor: backgroundColor,
                                cell: cell,
                                fontSize: fontSize,
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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

class _SearchGridItem extends StatelessWidget {
  const _SearchGridItem({
    required this.rowIndex,
    required this.colIndex,
    required this.cellSize,
    required this.backgroundColor,
    required this.cell,
    required this.fontSize,
  });

  final int rowIndex;
  final int colIndex;
  final double cellSize;
  final Color backgroundColor;
  final GridCell cell;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Check if the game is already won to prevent interaction
        if (context.read<LetterSearchCubit>().state.gameWon) {
          return;
        }
        context.read<LetterSearchCubit>().cellTapped(rowIndex, colIndex);
      },
      child: Container(
        margin: const EdgeInsets.all(2.0),
        width: cellSize,
        height: cellSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.black26, width: 0.5),
        ),
        child: Text(
          cell.letter,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LetterSearchError extends StatelessWidget {
  final String errorMessage;
  const _LetterSearchError(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              'Oops, something went wrong!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/images/png/sad-construction.png',
                width: 200,
                height: 200,
              ),
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
}
