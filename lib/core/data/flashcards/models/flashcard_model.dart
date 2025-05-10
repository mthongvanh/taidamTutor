// lib/models/flashcard_models.dart

/// Represents a single flashcard with Tai Dam character, pronunciation, and example.
class Flashcard {
  final String character;
  final String pronunciation;
  final String exampleWord;

  Flashcard({
    required this.character,
    required this.pronunciation,
    required this.exampleWord,
  });
}

/// Represents a deck of flashcards.
class FlashcardDeck {
  final String name;
  final List<Flashcard> flashcards;

  FlashcardDeck({
    required this.name,
    required this.flashcards,
  });
}