import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'flashcard_model.dart';

part 'flashcard_deck.g.dart';

/// Represents a collection of flashcards, each with a name and list of flashcards.
@JsonSerializable(explicitToJson: true)
class FlashcardDeck extends Equatable {
  /// The name of the flashcard deck.
  final String name;

  /// The list of flashcards in the deck.
  final List<Flashcard> flashcards;

  /// Creates a [FlashcardDeck] with the given [name] and [flashcards].
  const FlashcardDeck({required this.name, required this.flashcards});

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) =>
      _$FlashcardDeckFromJson(json);

  Map<String, dynamic> toJson() => _$FlashcardDeckToJson(this);

  @override
  List<Object?> get props => [
        name,
        flashcards,
      ];
}
