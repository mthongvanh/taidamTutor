import 'package:equatable/equatable.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_cubit.dart';
import 'package:taidam_tutor/feature/letter_search/widgets/letter_grid/core/data/models/grid_cell.dart';

class LetterSearchState extends Equatable {
  final SearchMode searchMode;
  final List<List<GridCell>> grid;
  final bool gameWon;
  final Character? targetLetter;
  final int gridSize;
  final bool isLoading;
  final String? errorMessage;

  const LetterSearchState({
    this.searchMode = SearchMode.singleCharacter,
    this.grid = const [],
    this.targetLetter,
    this.gridSize = 0,
    this.isLoading = true,
    this.errorMessage,
    this.gameWon = false,
  });

  LetterSearchState copyWith({
    SearchMode? searchMode,
    List<List<GridCell>>? grid,
    Character? targetLetter,
    int? gridSize,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? gameWon,
  }) {
    return LetterSearchState(
      searchMode: searchMode ?? this.searchMode,
      grid: grid ?? this.grid,
      targetLetter: targetLetter ?? this.targetLetter,
      gridSize: gridSize ?? this.gridSize,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      gameWon: gameWon ?? this.gameWon,
    );
  }

  @override
  List<Object?> get props => [
        grid,
        targetLetter,
        gridSize,
        isLoading,
        errorMessage,
        gameWon,
        searchMode,
      ];
}
