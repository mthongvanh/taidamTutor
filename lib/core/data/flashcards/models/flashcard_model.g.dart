// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flashcard _$FlashcardFromJson(Map<String, dynamic> json) => Flashcard(
      flashcardId: json['flashcardId'] as String,
      imageName: json['imageName'] as String,
      cardWord: json['cardWord'] as String,
      cardWordMeaning: json['cardWordMeaning'] as String,
      audioFile: json['vowelWordFile'] as String?,
    );

Map<String, dynamic> _$FlashcardToJson(Flashcard instance) => <String, dynamic>{
      'flashcardId': instance.flashcardId,
      'imageName': instance.imageName,
      'cardWord': instance.cardWord,
      'cardWordMeaning': instance.cardWordMeaning,
      'vowelWordFile': instance.audioFile,
    };
