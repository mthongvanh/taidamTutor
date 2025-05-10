// lib/models/flashcard_models.dart

/// Represents a single flashcard with Tai Dam character, pronunciation, and example.
class Flashcard {
  final int characterId; // ": 1,
  final String character; // ": "ꪀ",
  final String audioFile; // ": "a1",
  final String imageName; // ": "a1",
  final String svg; // ": "a1",
  final int characterType; // ": 1,
  final String highLow; // ": "low",
  final String sound; // ": "k",
  final String cardWord; // ": "ꪼꪀ",
  final String cardWordMeaning; // ": "chicken",
  final String? prePost; // ": "",
  final String? vowelWordFile;

  Flashcard({
  });
}

/// Represents a deck of flashcards.
class FlashcardDeck {
  final String name;
  final List<Flashcard> flashcards;

  FlashcardDeck({required this.name, required this.flashcards});
}
