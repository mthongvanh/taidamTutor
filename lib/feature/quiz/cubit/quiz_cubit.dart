import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/feature/quiz/core/data/models/quiz_question.dart';
import 'package:taidam_tutor/feature/quiz/cubit/quiz_state.dart';

// --- Quiz Cubit ---
class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial()) {
    loadQuestion();
  }

  // Sample questions - replace with your actual data source
  final List<QuizQuestion> _allQuestions = [
    QuizQuestion(
      id: '1',
      textQuestion: 'What is this character: ກ?',
      options: ['ก (kai)', 'ข (khai)', 'ค (khuai)', 'ง (ngua)'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      id: '2',
      // imagePath: 'assets/images/your_image.png', // Example
      textQuestion: 'Which sound does this represent?',
      audioPath:
          'assets/audio/sample_sound.mp3', // Example: ensure you have this asset
      options: ['Sound A', 'Sound B', 'Sound C', 'Sound D'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      id: '3',
      textQuestion: 'What is the Tai Dam word for "water"?',
      options: ['ນ້ຳ (nam)', 'ດິນ (din)', 'ໄຟ (fai)', 'ລົມ (lom)'],
      correctAnswerIndex: 0,
    ),
  ];
  
  int _currentQuestionIndex = 0;
  int _currentScore = 0;

  Future<void> loadQuestion() async {
    emit(QuizLoading());
    try {
      // Simulate network delay or actual data fetching
      await Future.delayed(const Duration(milliseconds: 500));
      if (_currentQuestionIndex < _allQuestions.length) {
        emit(QuizLoaded(
            currentQuestion: _allQuestions[_currentQuestionIndex],
            score: _currentScore));
      } else {
        // No more questions - could emit a QuizFinished state
        emit(QuizFinished(_currentScore)); // Or a specific "QuizFinished" state
      }
    } catch (e) {
      emit(QuizError('Failed to load question: ${e.toString()}'));
    }
  }

  void selectAnswer(int index) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final bool isCorrect =
          index == currentState.currentQuestion.correctAnswerIndex;
      if (isCorrect) {
        _currentScore++;
      }
      emit(currentState.copyWith(
        selectedAnswerIndex: index,
        isCorrect: isCorrect,
        score: _currentScore,
      ));
    }
  }

  void nextQuestion() {
    if (state is QuizLoaded) {
      _currentQuestionIndex++;
      loadQuestion(); // This will reset selectedAnswerIndex and isCorrect via QuizLoaded constructor
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _currentScore = 0;
    loadQuestion();
  }
}
