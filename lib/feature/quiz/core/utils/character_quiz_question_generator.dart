import 'dart:math';

import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/feature/quiz/core/data/models/quiz_question.dart';

class CharacterQuizQuestionGenerator {
  /// Generates a multiple-choice quiz question from a [CharacterModel].
  ///
  /// The question asks to identify the sound of the given character.
  /// [correctCharacter] is the character for which the question is generated.
  /// [allCharacters] is a list of all available characters to pick distractors from.
  /// [numberOfOptions] is the total number of choices for the multiple-choice question (including the correct one).
  QuizQuestion generateQuestionFromCharacter(
    Character correctCharacter,
    List<Character> allCharacters, {
    int numberOfOptions = 4,
  }) {
    if (numberOfOptions < 2) {
      throw ArgumentError('Number of options must be at least 2.');
    }
    if (allCharacters.length < numberOfOptions) {
      throw ArgumentError(
          'Not enough characters in allCharacters to generate the specified number of options.');
    }

    final String prompt = 'What is the sound of this character?';
    final String questionText = correctCharacter.character;
    final List<String> options = [];
    final Random random = Random();

    // Add the correct answer
    options.add(correctCharacter.sound);

    // Add distractors
    final List<Character> distractors = List<Character>.from(allCharacters)
      ..removeWhere((char) =>
          char.characterId ==
          correctCharacter
              .characterId); // Ensure no duplicates of correct answer model

    distractors.shuffle(random);

    for (int i = 0;
        options.length < numberOfOptions && i < distractors.length;
        i++) {
      if (!options.contains(distractors[i].sound)) {
        // Ensure unique sound options
        options.add(distractors[i].sound);
      }
    }

    // If not enough unique distractors were found from different characters,
    // this part might need more sophisticated logic, e.g. error handling or alternative distractor sources.
    // For now, we assume enough unique sounds are available.

    options.shuffle(random); // Shuffle all options

    final int correctAnswerIndex = options.indexOf(correctCharacter.sound);

    return QuizQuestion(
      id: 'char_${correctCharacter.characterId}_${DateTime.now().millisecondsSinceEpoch}',
      prompt: prompt,
      textQuestion: questionText,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
      // You might want to add the character itself or an image path to the question
      // e.g., characterDisplay: correctCharacter.character,
    );
  }
}
