import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable(explicitToJson: true)
class Character extends Equatable {
  /// Unique identifier for the character
  final int characterId;

  /// The character itself, e.g. ꪼ
  final String character;

  /// audio file name, e.g. a1.mp3
  final String audio;

  /// image of the character, e.g. svg filename
  final String image;

  /// english sound approximation
  final String sound;

  final int characterType;

  /// For consonants, whether it is high or low.
  final String? highLow;

  /// For vowels, whether it comes before or after the consonant.
  final String? prePost;

  //// Whether the character is a vowel, vowel-combo, consonant, or special character.
  final String characterClass;

  /// Regular expression for matching the character.
  final String? regEx;

  const Character({
    required this.characterId,
    required this.character,
    required this.audio,
    required this.sound,
    required this.characterType,
    required this.image,
    required this.characterClass,
    this.highLow,
    this.prePost,
    this.regEx,
  });

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  @override
  List<Object?> get props => [
        characterId,
        character,
        audio,
        sound,
        characterType,
        image,
        highLow,
        prePost,
        characterClass,
        regEx,
      ];
}
