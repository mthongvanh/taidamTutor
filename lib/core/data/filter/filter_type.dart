/// Filter based on different character, flashcard, or quiz queestion values types
///
/// These filters select the types of data to show in different features such as
/// flashcards, quizzes, and character review.
enum FilterType {
  none('none'),
  vowel('vowel'),
  consonant('consonant'),
  words('words'),
  phrases('phrases');

  final String value;
  const FilterType(this.value);

  static fromString(String value) {
    return FilterType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FilterType.none,
    );
  }

  @override
  String toString() {
    return value;
  }
}
