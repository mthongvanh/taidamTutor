import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:taidam_tutor/core/data/characters/character_repository.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/core/data/flashcards/flashcard_repository.dart';
import 'package:taidam_tutor/core/data/flashcards/models/flashcard_model.dart';
import 'package:taidam_tutor/core/di/dependency_manager.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_state.dart';
import 'package:taidam_tutor/feature/letter_search/widgets/letter_grid/core/data/models/grid_cell.dart';

enum SearchMode {
  singleCharacter,
  wordsContainingCharacter,
}

class LetterSearchCubit extends Cubit<LetterSearchState> {
  final _characterRepository = dm.get<CharacterRepository>();
  final _flashcardRepository = dm.get<FlashcardRepository>();
  final _audioPlayer = AudioPlayer();

  final Random _random = Random();

  late Character _currentTargetCharacter;
  String get _currentTargetLetter => _currentTargetCharacter.character;
  List<String> _currentAllowed = [];
  int _currentGridSize = 0;

  LetterSearchCubit() : super(const LetterSearchState(isLoading: true));

  void changeSearchMode() {
    final currentMode = state.searchMode;
    final searchMode = currentMode == SearchMode.singleCharacter
        ? SearchMode.wordsContainingCharacter
        : SearchMode.singleCharacter;
    initializeGrid(size: _currentGridSize, searchMode: searchMode);
  }

  void initializeGrid({
    required int size,
    SearchMode searchMode = SearchMode.wordsContainingCharacter,
    int retryCount = 0,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        gameWon: false,
        errorMessage: null,
        clearErrorMessage: true,
        searchMode: searchMode,
        grid: [],
      ),
    );

    try {
      if (!_validateGridSize(size)) return;

      final characters = await _characterRepository.getCharacters();
      final targetCharacter = _selectTargetCharacter(characters);
      final flashcards = await _flashcardRepository.getFlashcards();

      final uniqueAllowedOptions = _prepareUniqueAllowedOptions(
        target: targetCharacter.character,
        flashcards: flashcards,
        characters: characters,
        searchMode: searchMode,
        size: size,
      );

      if (!_validateTargetAndOptions(
          targetCharacter, uniqueAllowedOptions, searchMode)) {
        return;
      }

      _currentGridSize = size;
      _currentTargetCharacter = targetCharacter;
      _currentAllowed = uniqueAllowedOptions;

      final lettersPool = _buildLettersPool(
        uniqueAllowed: uniqueAllowedOptions,
        totalCells: size * size,
        searchMode: searchMode,
        size: size,
        target: targetCharacter,
      );

      if (lettersPool == null) {
        // Indicates an error was emitted in _buildLettersPool
        return;
      }

      if (lettersPool.isEmpty) {
        if (_handleEmptyLettersPool(size, searchMode, retryCount)) {
          return;
        }
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Oh no, we need more vocab data! Please try again.",
        ));
        return;
      }

      final newGrid = _generateNewGrid(size, lettersPool, searchMode);

      emit(state.copyWith(
        grid: newGrid,
        targetLetter: targetCharacter,
        gridSize: size,
        isLoading: false,
        errorMessage: null,
        clearErrorMessage: true,
      ));
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage: "Error initializing grid: $error",
          clearErrorMessage: true));
    }
  }

  bool _validateGridSize(int size) {
    if (size < 3) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Grid size must be at least 3x3."));
      return false;
    }
    return true;
  }

  Character _selectTargetCharacter(List<Character> characters) {
    return characters[_random.nextInt(characters.length)];
  }

  List<String> _prepareUniqueAllowedOptions({
    required String target,
    required List<Flashcard> flashcards,
    required List<Character> characters,
    required SearchMode searchMode,
    required int size,
  }) {
    return _buildOptions(
            target: target,
            flashcards: flashcards,
            characters: characters,
            searchMode: searchMode,
            size: size)
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }

  bool _validateTargetAndOptions(
    Character target,
    List<String> uniqueAllowed,
    SearchMode searchMode,
  ) {
    if (!_isValid(target, uniqueAllowed, searchMode)) {
      // _isValid already emits the state with an error message
      return false;
    }
    return true;
  }

  List<String>? _buildLettersPool({
    required List<String> uniqueAllowed,
    required int totalCells,
    required SearchMode searchMode,
    required int size,
    required Character target,
  }) {
    if (searchMode == SearchMode.singleCharacter) {
      const minOccurrences = 3;
      if (uniqueAllowed.length * minOccurrences > totalCells) {
        emit(state.copyWith(
          isLoading: false,
          gridSize: size,
          targetLetter: target,
          errorMessage:
              "Not enough cells for ${uniqueAllowed.length} unique letters (each needing $minOccurrences spots) in a ${size}x$size grid. Total cells: $totalCells, Minimum required: ${uniqueAllowed.length * minOccurrences}.",
        ));
        return null; // Indicate error by returning null
      }
      return _buildSingleLetterPool(
        uniqueAllowed: uniqueAllowed,
        totalCells: totalCells,
        minOccurrences: minOccurrences,
      );
    } else {
      return uniqueAllowed;
    }
  }

  bool _handleEmptyLettersPool(
      int size, SearchMode searchMode, int retryCount) {
    if (retryCount < 3) {
      initializeGrid(
        size: size,
        searchMode: searchMode,
        retryCount: retryCount + 1,
      );
      return true; // Indicates retry was initiated
    }
    return false; // Indicates max retries reached
  }

  List<List<GridCell>> _generateNewGrid(
      int size, List<String> lettersPool, SearchMode searchMode) {
    return List.generate(
      size,
      (row) => List.generate(size, (col) {
        final letter = lettersPool[row * size + col];
        return GridCell(
          letter: letter,
          isTarget: _isTarget(_currentTargetLetter, letter, searchMode),
          isRevealed: false,
        );
      }),
    );
  }

  List<String> _buildSingleLetterPool({
    required List<String> uniqueAllowed,
    required int totalCells,
    required int minOccurrences,
  }) {
    List<String> lettersPool = [];
    for (var letter in uniqueAllowed) {
      for (int i = 0; i < minOccurrences; i++) {
        lettersPool.add(letter);
      }
    }

    int remainingCells = totalCells - lettersPool.length;
    for (int i = 0; i < remainingCells; i++) {
      lettersPool.add(uniqueAllowed[i % uniqueAllowed.length]);
    }

    lettersPool.shuffle(_random);
    return lettersPool;
  }

  bool _isTarget(String target, String character, SearchMode searchMode) {
    if (searchMode == SearchMode.singleCharacter) {
      return character.trim().toUpperCase() == target.trim().toUpperCase();
    } else {
      return character
          .trim()
          .toUpperCase()
          .contains(target.trim().toUpperCase());
    }
  }

  bool _isValid(
    Character targetLetter,
    List<String> uniqueAllowed,
    SearchMode searchMode,
  ) {
    final String upperTargetLetter =
        targetLetter.character.trim().toUpperCase();
    if (upperTargetLetter.isEmpty) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Target letter must not be empty."));
      return false;
    }

    if (uniqueAllowed.isEmpty) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Allowed list cannot be empty."));
      return false;
    }

    if (searchMode == SearchMode.singleCharacter &&
        !uniqueAllowed.contains(upperTargetLetter)) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage:
              "Target letter '$upperTargetLetter' must be in the list of allowed letters: ${uniqueAllowed.join(', ')}."));
      return false;
    }

    if (searchMode == SearchMode.wordsContainingCharacter &&
        !uniqueAllowed.any((e) => e.contains(upperTargetLetter))) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage:
              "Target letter '$upperTargetLetter' must be in the list of allowed letters: ${uniqueAllowed.join(', ')}."));
      return false;
    }
    return true;
  }

  List<String> _buildOptions({
    required String target,
    required List<Character> characters,
    required SearchMode searchMode,
    required int size,
    List<Flashcard> flashcards = const [],
  }) {
    List<String> randomAllowed;
    if (searchMode == SearchMode.singleCharacter) {
      randomAllowed = characters
          .where(((e) => e.character != target))
          .map((e) => e.character)
          .toList();
      randomAllowed.shuffle();
      randomAllowed = randomAllowed.take(max(0, size - 1)).toList();
      randomAllowed.add(target);
    } else {
      final matches = <String>[];
      final random = <String>[];
      for (var flashcard in flashcards) {
        if (flashcard.question.contains(target)) {
          matches.add(flashcard.question);
        } else {
          random.add(flashcard.question);
        }
      }

      if (matches.isEmpty && random.isEmpty) {
        emit(state.copyWith(
            isLoading: false,
            errorMessage:
                "No matches found for target letter '$target' in flashcards."));
        return [];
      }

      randomAllowed = matches.take(3).toList();
      random.shuffle();
      randomAllowed.addAll(random);
      randomAllowed = randomAllowed.take(size * size).toList();
    }
    return randomAllowed;
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
    if (_currentGridSize >= 3 && _currentAllowed.isNotEmpty) {
      initializeGrid(
        size: _currentGridSize,
        searchMode: state.searchMode,
      );
    } else {
      emit(state.copyWith(
          isLoading: false,
          errorMessage:
              "Cannot reset: initial parameters are not valid or not set. Please re-initialize with correct parameters."));
    }
  }
}
