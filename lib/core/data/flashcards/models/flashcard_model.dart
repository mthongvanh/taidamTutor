// lib/models/flashcard_models.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flashcard_model.g.dart';

/// Represents a flashcard with an image, word, and its meaning.
@JsonSerializable(explicitToJson: true)
class Flashcard extends Equatable {
  /// Unique identifier for the flashcard
  final int flashcardId;

  /// image that represents the card word meaning
  final String image;

  /// Item to review
  final String question;

  /// Item description
  final String answer;

  /// File name of the card audio file
  final String? audio;

  /// Constructor for the Flashcard class.
  const Flashcard({
    required this.flashcardId,
    required this.image,
    required this.question,
    required this.answer,
    this.audio,
  });

  /// Creates a Flashcard instance from a JSON object.
  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFromJson(json);

  /// Creates a Flashcard instance from a JSON object.
  Map<String, dynamic> toJson() => _$FlashcardToJson(this);

  @override
  List<Object?> get props => [
        flashcardId,
        image,
        question,
        answer,
        audio,
      ];
}
