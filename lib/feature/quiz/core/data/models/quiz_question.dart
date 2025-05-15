// Define a model for your quiz question (can be the same as before or enhanced)
import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  final String id;
  final String? textQuestion;
  final String? imagePath;
  final String? audioPath;
  final List<String> options;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.id,
    this.textQuestion,
    this.imagePath,
    this.audioPath,
    required this.options,
    required this.correctAnswerIndex,
  }) : assert(textQuestion != null || imagePath != null || audioPath != null,
            'A question must have either text, an image, or an audio path.');

  @override
  List<Object?> get props =>
      [id, textQuestion, imagePath, audioPath, options, correctAnswerIndex];
}
