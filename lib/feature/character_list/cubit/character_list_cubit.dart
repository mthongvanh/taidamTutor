import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/character_repository.dart';
import 'package:taidam_tutor/core/di/dependency_manager.dart';
import 'package:taidam_tutor/feature/character_list/cubit/character_list_state.dart';

class CharacterListCubit extends Cubit<CharacterListState> {
  final CharacterRepository _repository;

  CharacterListCubit()
      : _repository = dm.get<CharacterRepository>(),
        super(CharacterInitial()) {
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    try {
      emit(CharacterLoading());
      final characters = await _repository.getCharacters();

      final consonants =
          characters.where((c) => c.characterClass == "consonant").toList();
      final vowels =
          characters.where((c) => c.characterClass == "vowel").toList();
      final vowelFinals =
          characters.where((c) => c.characterClass == "vowel-final").toList();
      final vowelCombinations =
          characters.where((c) => c.characterClass == "vowel-combo").toList();
      final specialCharacters =
          characters.where((c) => c.characterClass == "special").toList();

      // Optionally, sort each list if needed (e.g., by sound or a specific order)
      consonants.sort((a, b) => a.sound.compareTo(b.sound));
      vowels.sort((a, b) => a.sound.compareTo(b.sound));
      vowelFinals.sort((a, b) => a.sound.compareTo(b.sound));
      vowelCombinations.sort((a, b) => a.sound.compareTo(b.sound));
      specialCharacters.sort((a, b) => a.sound.compareTo(b.sound));

      emit(CharacterLoaded(
        consonants: consonants,
        vowels: vowels,
        vowelFinals: vowelFinals,
        vowelCombinations: vowelCombinations,
        specialCharacters: specialCharacters,
      ));
    } catch (e) {
      emit(CharacterError("Failed to load characters: ${e.toString()}"));
    }
  }
}
