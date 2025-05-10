import 'package:taidamTutor/core/data/flashcards/flashcard_local_data_source.dart';

import 'models/flashcard_model.dart';

class FlashcardRepository {
  final FlashcardLocalDataSource _localDataSource;

  FlashcardRepository() : _localDataSource = FlashcardLocalDataSource()..init();

  Future<List<Flashcard>> getFlashcards() async {
    return _localDataSource.getFlashcards();
  }
}
