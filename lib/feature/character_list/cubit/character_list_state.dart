import 'package:equatable/equatable.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart'; // Add equatable for value comparison if desired

sealed class CharacterListState extends Equatable {
  const CharacterListState();

  @override
  List<Object> get props => [];
}

class CharacterInitial extends CharacterListState {}

class CharacterLoading extends CharacterListState {}

class CharacterLoaded extends CharacterListState {
  final List<Character> consonants;
  final List<Character> vowels;
  final List<Character> vowelFinals;
  final List<Character> vowelCombinations;
  final List<Character> specialCharacters;

  const CharacterLoaded({
    required this.consonants,
    required this.vowels,
    required this.vowelFinals,
    required this.vowelCombinations,
    required this.specialCharacters,
  });

  @override
  List<Object> get props => [
        consonants,
        vowels,
        specialCharacters,
        vowelFinals,
        vowelCombinations,
      ];
}

class CharacterError extends CharacterListState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object> get props => [message];
}
