// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flashcard _$FlashcardFromJson(Map<String, dynamic> json) => Flashcard(
      flashcardId: (json['flashcardId'] as num).toInt(),
      image: json['image'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      audio: json['audio'] as String?,
    );

Map<String, dynamic> _$FlashcardToJson(Flashcard instance) => <String, dynamic>{
      'flashcardId': instance.flashcardId,
      'image': instance.image,
      'question': instance.question,
      'answer': instance.answer,
      'audio': instance.audio,
    };
