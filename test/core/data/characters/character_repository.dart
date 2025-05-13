import 'character_local_data_source.dart';
import 'models/character.dart';

class CharacterRepository {
  final CharacterLocalDataSource _localDataSource;

  CharacterRepository() : _localDataSource = CharacterLocalDataSource()..init();

  Future<List<Character>> getCharacters() async {
    return _localDataSource.getCharacters();
  }
}
