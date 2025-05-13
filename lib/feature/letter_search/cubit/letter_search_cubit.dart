import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/character_repository.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/core/di/dependency_manager.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_state.dart';
import 'package:taidam_tutor/feature/letter_search/widgets/letter_grid/core/data/models/grid_cell.dart';

class LetterSearchCubit extends Cubit<LetterSearchState> {
  final _characterRepository = dm.get<CharacterRepository>();
  final Random _random = Random();

  late Character _currentTargetLetter;
  List<Character> _currentAllowedLetters = [];
  int _currentGridSize = 0;

  LetterSearchCubit() : super(const LetterSearchState(isLoading: true));

  void initializeGrid({
    required int size,
    // required Character targetLetter,
    // required List<Character> allowedLettersInput,
  }) {
    emit(state.copyWith(
        isLoading: true,
        gameWon: false,
        errorMessage: null,
        clearErrorMessage: true,
        grid: []));

    _characterRepository.getCharacters().then((value) {
      debugPrint('Characters loaded: $value');
      final targetLetter = value[Random().nextInt(value.length)];
      final randomAllowedLetters =
          value.where(((e) => e != targetLetter)).toList();

      randomAllowedLetters.shuffle();
      final allowedLetters = randomAllowedLetters.take(4).toList();
      allowedLetters.add(targetLetter);

      if (size < 5) {
        emit(state.copyWith(
            isLoading: false, errorMessage: "Grid size must be at least 5x5."));
        return;
      }

      final String upperTargetLetter =
          targetLetter.character.trim().toUpperCase();
      // if (upperTargetLetter.isEmpty || upperTargetLetter.length > 1) {
      if (upperTargetLetter.isEmpty) {
        emit(state.copyWith(
            isLoading: false,
            errorMessage: "Target letter must be a single character."));
        return;
      }

      if (allowedLetters.isEmpty) {
        emit(state.copyWith(
            isLoading: false,
            errorMessage: "Allowed letters list cannot be empty."));
        return;
      }

      final uniqueAllowedLetters = allowedLetters
          .map((e) => e.character.trim().toUpperCase())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      if (uniqueAllowedLetters.isEmpty) {
        emit(state.copyWith(
            isLoading: false,
            errorMessage:
                "Allowed letters list is empty after processing. Please provide valid letters."));
        return;
      }

      if (!uniqueAllowedLetters.contains(upperTargetLetter)) {
        emit(state.copyWith(
            isLoading: false,
            errorMessage:
                "Target letter '$upperTargetLetter' must be in the list of allowed letters: ${uniqueAllowedLetters.join(', ')}."));
        return;
      }

      _currentGridSize = size;
      _currentTargetLetter = targetLetter;
      _currentAllowedLetters = allowedLetters;

      final totalCells = size * size;
      const minOccurrences = 5;

      if (uniqueAllowedLetters.length * minOccurrences > totalCells) {
        emit(state.copyWith(
          isLoading: false,
          gridSize: size,
          targetLetter: targetLetter,
          errorMessage:
              "Not enough cells for ${uniqueAllowedLetters.length} unique letters (each needing $minOccurrences spots) in a ${size}x$size grid. Total cells: $totalCells, Minimum required: ${uniqueAllowedLetters.length * minOccurrences}.",
        ));
        return;
      }

      List<String> lettersPool = [];
      for (var letter in uniqueAllowedLetters) {
        for (int i = 0; i < minOccurrences; i++) {
          lettersPool.add(letter);
        }
      }

      int remainingCells = totalCells - lettersPool.length;
      for (int i = 0; i < remainingCells; i++) {
        lettersPool.add(uniqueAllowedLetters[i % uniqueAllowedLetters.length]);
      }

      lettersPool.shuffle(_random);

      final newGrid = List.generate(
        size,
        (row) => List.generate(size, (col) {
          final letter = lettersPool[row * size + col];
          return GridCell(
            letter: letter,
            isTarget: letter == upperTargetLetter,
            isRevealed: false,
          );
        }),
      );

      emit(state.copyWith(
        grid: newGrid,
        targetLetter: targetLetter,
        gridSize: size,
        isLoading: false,
        errorMessage: null,
        clearErrorMessage: true,
      ));
    }).catchError((error) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage: "Error loading characters: $error",
          clearErrorMessage: true));
    });
  }

  void cellTapped(int row, int col) {
    if (state.isLoading ||
        state.grid.isEmpty ||
        row < 0 ||
        row >= state.gridSize ||
        col < 0 ||
        col >= state.gridSize) {
      return;
    }

    // If the tapped cell is an unrevealed target, this code creates a new grid copy,
    //marks that specific cell as revealed, and then updates the game state with this
    //new grid, triggering a UI refresh.
    final cell = state.grid[row][col];
    if (cell.isTarget && !cell.isRevealed) {
      final newGridData = state.grid.map((gridRow) {
        return gridRow.map((c) => c.copyWith()).toList();
      }).toList();

      newGridData[row][col] = newGridData[row][col].copyWith(isRevealed: true);

      // Check if all target letters are now revealed
      bool allTargetsFound = true;
      for (var r = 0; r < newGridData.length; r++) {
        for (var c = 0; c < newGridData[r].length; c++) {
          if (newGridData[r][c].isTarget && !newGridData[r][c].isRevealed) {
            allTargetsFound = false;
            break;
          }
        }
        if (!allTargetsFound) break;
      }

      emit(state.copyWith(grid: newGridData, gameWon: allTargetsFound));
    }
  }

  void resetGrid() {
    if (_currentGridSize >= 5 && _currentAllowedLetters.isNotEmpty) {
      initializeGrid(
        size: _currentGridSize,
      );
    } else {
      emit(state.copyWith(
          isLoading: false,
          errorMessage:
              "Cannot reset: initial parameters are not valid or not set. Please re-initialize with correct parameters."));
    }
  }
}
