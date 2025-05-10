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
  final String audioFile;

  /// image of the character, e.g. svg filename
  @JsonKey(name: 'svg')
  final String imageFile;

  /// english sound approximation
  final String sound;

  /// Whether the character is a vowel or consonant.
  final int characterType;

  /// For consonants, whether it is high or low.
  final String? highLow;

  /// For vowels, whether it comes before or after the consonant.
  final String? prePost;

  const Character({
    required this.characterId,
    required this.character,
    required this.audioFile,
    required this.sound,
    required this.characterType,
    required this.imageFile,
    this.highLow,
    this.prePost,
  });

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  @override
  List<Object?> get props => [
        characterId,
        character,
        audioFile,
        sound,
        characterType,
        highLow,
        prePost,
      ];
}
