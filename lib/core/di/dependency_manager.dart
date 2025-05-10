import 'package:get_it/get_it.dart';
import 'package:taidam_tutor/core/data/characters/character_repository.dart';
import 'package:taidam_tutor/core/data/flashcards/flashcard_repository.dart';

class DependencyManager {
  static final DependencyManager _instance = DependencyManager._internal();

  factory DependencyManager() {
    return _instance;
  }

  DependencyManager._internal();

  void registerDependencies() {
    GetIt.I.registerLazySingleton<FlashcardRepository>(
        () => FlashcardRepository());
    GetIt.I.registerLazySingleton<CharacterRepository>(
        () => CharacterRepository());
  }
}
