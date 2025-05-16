// Define a model for your quiz question (can be the same as before or enhanced)
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_question.g.dart';

@JsonSerializable(explicitToJson: true)
class QuizQuestion extends Equatable {
  final String id;

  /// Prompt for the question, e.g., "What is the sound of this character?"
  final String? prompt;

  /// Text question, e,g. the character itself or word to be identified
  final String? textQuestion;

  /// Path to an image asset (if applicable)
  final String? imagePath;

  /// Path to an audio asset (if applicable)
  final String? audioPath;

  /// List of answer options
  final List<String> options;

  /// Index of the correct answer in the options list
  final int correctAnswerIndex;

  /// Explanation for the correct answer (optional)
  final String? explanation;

  /// List of hints for the question (optional)
  final List<String>? hints;

  /// List of tags for categorization (optional)
  final List<String> tags;

  const QuizQuestion({
    required this.id,
    required this.options,
    required this.correctAnswerIndex,
    this.prompt,
    this.textQuestion,
    this.imagePath,
    this.audioPath,
    this.explanation,
    this.hints,
    this.tags = const [],
  }) : assert(textQuestion != null || imagePath != null || audioPath != null,
            'A question must have either text, an image, or an audio path.');

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);

  @override
  List<Object?> get props => [
        id,
        prompt,
        textQuestion,
        imagePath,
        audioPath,
        options,
        correctAnswerIndex,
        explanation,
        hints,
        tags,
      ];
}
