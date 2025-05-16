// --- Quiz States ---
import 'package:equatable/equatable.dart';
import 'package:taidam_tutor/feature/quiz/core/data/models/quiz_question.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final QuizQuestion currentQuestion;
  final int? selectedAnswerIndex;
  final bool? isCorrect;
  final int score; // Optional: track score

  const QuizLoaded({
    required this.currentQuestion,
    this.selectedAnswerIndex,
    this.isCorrect,
    this.score = 0,
  });

  QuizLoaded copyWith({
    QuizQuestion? currentQuestion,
    int? selectedAnswerIndex,
    bool? isCorrect,
    bool clearSelectedAnswer =
        false, // Helper to nullify selectedAnswerIndex and isCorrect
    int? score,
  }) {
    return QuizLoaded(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedAnswerIndex: clearSelectedAnswer
          ? null
          : (selectedAnswerIndex ?? this.selectedAnswerIndex),
      isCorrect: clearSelectedAnswer ? null : (isCorrect ?? this.isCorrect),
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props =>
      [currentQuestion, selectedAnswerIndex, isCorrect, score];
}

class QuizFinished extends QuizState {
  final int score;
  final String? image;

  const QuizFinished(this.score, {this.image});

  QuizFinished copyWith({
    int? score,
    String? image,
  }) {
    return QuizFinished(
      score ?? this.score,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [score];
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
