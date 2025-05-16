import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/character_repository.dart';
import 'package:taidam_tutor/core/di/dependency_manager.dart';
import 'package:taidam_tutor/feature/quiz/core/data/models/quiz_question.dart';
import 'package:taidam_tutor/feature/quiz/core/utils/character_quiz_question_generator.dart';
import 'package:taidam_tutor/feature/quiz/cubit/quiz_state.dart';

enum QuizMode { character }

// --- Quiz Cubit ---
class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial()) {
    initQuiz();
  }

  // Sample questions - replace with your actual data source
  final List<QuizQuestion> _allQuestions = [];

  int _currentQuestionIndex = 0;
  int _currentScore = 0;

  void initQuiz() {
    emit(QuizInitial());
    _currentQuestionIndex = 0;
    _currentScore = 0;
    createQuestions();
    // Load the first question
    loadQuestion();
  }

  void createQuestions() async {
    // This function can be used to create questions dynamically
    // For example, you can fetch from an API or generate based on some logic
    final characters = dm.get<CharacterRepository>();
    final allCharacters = await characters.getCharacters();
    final questionGenerator = CharacterQuizQuestionGenerator();
    final questions = <QuizQuestion>[];
    allCharacters.shuffle();
    for (var character in allCharacters.take(10).toList()) {
      final question = questionGenerator.generateQuestionFromCharacter(
        character,
        allCharacters,
        numberOfOptions: 4,
      );
      questions.add(question);
    }
    _allQuestions.clear();
    _allQuestions.addAll(questions);
  }

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
        emit(
          QuizFinished(
            _currentScore,
            image: _imageForScore(
              _currentScore / _allQuestions.length.toDouble(),
            ),
          ),
        ); // Or a specific "QuizFinished" state
      }
    } catch (e) {
      emit(QuizError('Failed to load question: ${e.toString()}'));
    }
  }

  String _imageForScore(double percentage) {
    if (percentage > 0.8) {
      return 'assets/images/png/jump-joy.png';
    } else if (percentage > 0.5) {
      return 'assets/images/png/studying.png';
    } else {
      return 'assets/images/png/sad-face.png';
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

      // Optionally, you can add a delay before moving to the next question
      // to show the user that they got it right.
      Future.delayed(const Duration(seconds: 2), () {
        nextQuestion();
      });
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
    initQuiz();
  }
}
