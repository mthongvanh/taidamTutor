// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
      id: json['id'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
      prompt: json['prompt'] as String?,
      textQuestion: json['textQuestion'] as String?,
      imagePath: json['imagePath'] as String?,
      audioPath: json['audioPath'] as String?,
      explanation: json['explanation'] as String?,
      hints:
          (json['hints'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prompt': instance.prompt,
      'textQuestion': instance.textQuestion,
      'imagePath': instance.imagePath,
      'audioPath': instance.audioPath,
      'options': instance.options,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'explanation': instance.explanation,
      'hints': instance.hints,
      'tags': instance.tags,
    };
