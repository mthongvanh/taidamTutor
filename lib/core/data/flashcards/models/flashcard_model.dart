// lib/models/flashcard_models.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:taidam_tutor/core/data/flashcards/models/hint.dart';

part 'flashcard_model.g.dart';

/// Represents a flashcard with an image, word, and its meaning.
@JsonSerializable(explicitToJson: true)
class Flashcard extends Equatable {
  /// image that represents the card word meaning
  final String? image;

  /// Item to review
  final String question;

  /// Item description
  final String answer;

  /// File name of the card audio file
  final String? audio;

  /// List of hints for the flashcard
  final List<Hint>? hints;

  /// Constructor for the Flashcard class.
  const Flashcard({
    required this.image,
    required this.question,
    required this.answer,
    this.audio,
    this.hints = const [],
  });

  /// Creates a Flashcard instance from a JSON object.
  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFromJson(json);

  /// Creates a Flashcard instance from a JSON object.
  Map<String, dynamic> toJson() => _$FlashcardToJson(this);

  @override
  List<Object?> get props => [
        image,
        question,
        answer,
        audio,
        hints,
      ];
}
