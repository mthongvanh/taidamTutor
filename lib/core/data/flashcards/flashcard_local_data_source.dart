import 'package:myapp/core/clients/sqlite/sqlite_client.dart';
import 'package:myapp/core/data/flashcards/models/flashcard_model.dart'
    show Flashcard;

class FlashcardLocalDataSource {
  final SqliteClient _client;

  FlashcardLocalDataSource()
    : _client = SqliteClient('assets/data/MojoDatabase.sqlite3');

  Future<void> saveFlashcard(Flashcard flashcard) {
    throw UnimplementedError();
  }

  Future<List<Flashcard>> getFlashcards() => throw UnimplementedError();
  Future<void> deleteFlashcard(String id) => throw UnimplementedError();
}
