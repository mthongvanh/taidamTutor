// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_deck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashcardDeck _$FlashcardDeckFromJson(Map<String, dynamic> json) =>
    FlashcardDeck(
      name: json['name'] as String,
      flashcards: (json['flashcards'] as List<dynamic>)
          .map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlashcardDeckToJson(FlashcardDeck instance) =>
    <String, dynamic>{
      'name': instance.name,
      'flashcards': instance.flashcards.map((e) => e.toJson()).toList(),
    };
