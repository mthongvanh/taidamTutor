import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:taidamTutor/core/data/flashcards/models/flashcard_model.dart';

class FlashcardLocalDataSource {
  final _flashcards = <Flashcard>[];

  FlashcardLocalDataSource();

  Future<void> init() async {
    final jsonString =
        await rootBundle.loadString('assets/data/character.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _flashcards.addAll(
      jsonList.map((json) => Flashcard.fromJson(json)).toList(),
    );
  }

  void saveFlashcard(Flashcard flashcard) {
    if (_flashcards.any((fc) => fc == flashcard)) {
      return;
    }
  }

  List<Flashcard> getFlashcards() => _flashcards;

  void deleteFlashcard(Flashcard flashcard) => _flashcards.remove(flashcard);
}
