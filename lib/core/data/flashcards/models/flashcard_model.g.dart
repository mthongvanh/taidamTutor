// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flashcard _$FlashcardFromJson(Map<String, dynamic> json) => Flashcard(
      image: json['image'] as String?,
      question: json['question'] as String,
      answer: json['answer'] as String,
      audio: json['audio'] as String?,
      hints: (json['hints'] as List<dynamic>?)
              ?.map((e) => Hint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FlashcardToJson(Flashcard instance) => <String, dynamic>{
      'image': instance.image,
      'question': instance.question,
      'answer': instance.answer,
      'audio': instance.audio,
      'hints': instance.hints?.map((e) => e.toJson()).toList(),
    };
