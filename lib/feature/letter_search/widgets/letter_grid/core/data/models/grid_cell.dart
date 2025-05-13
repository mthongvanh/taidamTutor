import 'package:equatable/equatable.dart';

class GridCell extends Equatable {
  final String letter;
  final bool isTarget;
  final bool isRevealed;

  const GridCell({
    required this.letter,
    required this.isTarget,
    this.isRevealed = false,
  });

  GridCell copyWith({
    String? letter,
    bool? isTarget,
    bool? isRevealed,
  }) {
    return GridCell(
      letter: letter ?? this.letter,
      isTarget: isTarget ?? this.isTarget,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  @override
  List<Object?> get props => [letter, isTarget, isRevealed];
}
