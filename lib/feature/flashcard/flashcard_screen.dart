import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/core/data/flashcards/models/flashcard_model.dart';
import 'package:taidam_tutor/feature/flashcard/cubit/character_flashcards_cubit.dart';

class CharacterFlashcardsScreen extends StatelessWidget {
  final Character characterModel;

  const CharacterFlashcardsScreen({
    super.key,
    required this.characterModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards for '${characterModel.character}'"),
      ),
      body: BlocProvider(
        create: (context) => CharacterFlashcardsCubit(characterModel),
        child: CharacterFlashcardsView(
            characterToHighlight: characterModel.character),
      ),
    );
  }
}

class CharacterFlashcardsView extends StatelessWidget {
  final String characterToHighlight;
  const CharacterFlashcardsView(
      {super.key, required this.characterToHighlight});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterFlashcardsCubit, CharacterFlashcardsState>(
      builder: (context, state) {
        switch (state.status) {
          case CharacterFlashcardsStatus.initial:
            // The cubit calls fetchFlashcards in its constructor,
            // so initial might be brief or skipped if loading starts immediately.
            return const Center(child: Text("Initializing..."));
          case CharacterFlashcardsStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case CharacterFlashcardsStatus.failure:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Failed to load flashcards: ${state.errorMessage ?? 'Unknown error'}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          case CharacterFlashcardsStatus.success:
            if (state.flashcards.isEmpty) {
              return Center(
                child: Text(
                  "No flashcards found containing the character '$characterToHighlight'.",
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: state.flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = state.flashcards[index];
                return FlashcardItemWidget(
                  flashcard: flashcard,
                  characterToHighlight: characterToHighlight,
                );
              },
            );
        }
      },
    );
  }
}

class FlashcardItemWidget extends StatelessWidget {
  final Flashcard flashcard;
  final String characterToHighlight;

  final player = AudioPlayer();

  FlashcardItemWidget({
    super.key,
    required this.flashcard,
    required this.characterToHighlight,
  });

  List<TextSpan> _highlightOccurrences(
      String text, String query, BuildContext context) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: text)];
    }
    final List<TextSpan> spans = [];
    int start = 0;
    final TextStyle? defaultStyle = Theme.of(context).textTheme.bodyMedium;
    final TextStyle highlightStyle = defaultStyle?.copyWith(
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.redAccent,
        ) ??
        const TextStyle(
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.redAccent,
        );

    while (start < text.length) {
      final int matchPosition =
          text.toLowerCase().indexOf(query.toLowerCase(), start);
      if (matchPosition == -1) {
        spans.add(TextSpan(text: text.substring(start), style: defaultStyle));
        break;
      }
      if (matchPosition > start) {
        spans.add(TextSpan(
            text: text.substring(start, matchPosition), style: defaultStyle));
      }
      spans.add(TextSpan(
        text: text.substring(matchPosition, matchPosition + query.length),
        style: highlightStyle,
      ));
      start = matchPosition + query.length;
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (flashcard.audio != null && flashcard.audio!.isNotEmpty) {
          player.play(AssetSource('audio/${flashcard.audio}.caf'));
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: "Front: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: flashcard.question,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: "Back: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: flashcard.answer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
