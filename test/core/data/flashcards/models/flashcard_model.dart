// lib/models/flashcard_models.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flashcard_model.g.dart';

/// Represents a flashcard with an image, word, and its meaning.
@JsonSerializable(explicitToJson: true)
class Flashcard extends Equatable {
  /// image that represents the card word meaning
  final String imageName;

  /// characters that comprise the card word
  final String cardWord;

  /// English meaning of the card word
  final String cardWordMeaning;

  /// File name of the card word's audio file
  @JsonKey(name: "cardWordAudio")
  final String? audioFile;

  /// Constructor for the Flashcard class.
  const Flashcard({
    required this.imageName,
    required this.cardWord,
    required this.cardWordMeaning,
    this.audioFile,
  });

  /// Creates a Flashcard instance from a JSON object.
  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFromJson(json);

  /// Creates a Flashcard instance from a JSON object.
  Map<String, dynamic> toJson() => _$FlashcardToJson(this);

  @override
  List<Object?> get props => [
        imageName,
        cardWord,
        cardWordMeaning,
        audioFile,
      ];
}
