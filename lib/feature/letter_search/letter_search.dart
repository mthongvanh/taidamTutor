import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/feature/letter_search/cubit/letter_search_cubit.dart';
import 'package:taidam_tutor/feature/letter_search/widgets/letter_grid/letter_grid.dart';

class LetterSearchGame extends StatelessWidget {
  final int gridSize;

  const LetterSearchGame({
    super.key,
    this.gridSize = 5,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LetterSearchCubit()
        ..initializeGrid(
          size: gridSize,
        ),
      child: const LetterGrid(),
    );
  }
}
