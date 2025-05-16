import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/core/data/flashcards/flashcard_repository.dart';
import 'package:taidam_tutor/core/data/flashcards/models/flashcard_model.dart';
import 'package:taidam_tutor/core/di/dependency_manager.dart';

class CharacterFlashcardsCubit extends Cubit<CharacterFlashcardsState> {
  CharacterFlashcardsCubit(this.characterModel)
      : super(const CharacterFlashcardsState()) {
    fetchFlashcards();
  }

  final FlashcardRepository _flashcardRepository =
      dm.get<FlashcardRepository>();
  final Character characterModel;

  Future<void> fetchFlashcards() async {
    emit(state.copyWith(status: CharacterFlashcardsStatus.loading));
    try {
      final flashcards = await _flashcardRepository.getFlashcards();

      // Filter flashcards based on the character model
      final filteredFlashcards = flashcards.where(
        (flashcard) {
          if (characterModel.characterClass == 'vowel-combo') {
            final regEx = RegExp(characterModel.regEx ?? '');
            return regEx.hasMatch(flashcard.question) ||
                regEx.hasMatch(flashcard.answer);
          } else {
            return flashcard.question.contains(characterModel.character) ||
                flashcard.answer.contains(characterModel.character);
          }
        },
      ).toList();

      emit(state.copyWith(
        status: CharacterFlashcardsStatus.success,
        flashcards: filteredFlashcards,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharacterFlashcardsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

enum CharacterFlashcardsStatus { initial, loading, success, failure }

class CharacterFlashcardsState extends Equatable {
  const CharacterFlashcardsState({
    this.status = CharacterFlashcardsStatus.initial,
    this.flashcards = const <Flashcard>[],
    this.errorMessage,
  });

  final CharacterFlashcardsStatus status;
  final List<Flashcard> flashcards;
  final String? errorMessage;

  CharacterFlashcardsState copyWith({
    CharacterFlashcardsStatus? status,
    List<Flashcard>? flashcards,
    String? errorMessage,
  }) {
    return CharacterFlashcardsState(
      status: status ?? this.status,
      flashcards: flashcards ?? this.flashcards,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, flashcards, errorMessage];
}
