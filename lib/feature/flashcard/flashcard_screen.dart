import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/core/data/flashcards/models/flashcard_model.dart';
import 'package:taidam_tutor/feature/flashcard/cubit/character_flashcards_cubit.dart';
import 'package:taidam_tutor/utils/extensions/card_ext.dart';
import 'package:taidam_tutor/utils/extensions/text_ext.dart';

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
        title: TaiText.appBarTitle(
          "Words with ${characterModel.character}",
          context,
        ),
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
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = state.flashcards[index];
                return FlashcardItemWidget(
                  flashcard: flashcard,
                  characterToHighlight: characterToHighlight,
                );
              },
              padding: const EdgeInsets.all(8),
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

  @override
  Widget build(BuildContext context) {
    return TaiCard(
      child: InkWell(
        onTap: () {
          if (flashcard.audio != null && flashcard.audio!.isNotEmpty) {
            player.play(AssetSource('audio/${flashcard.audio}.caf'));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                flashcard.question,
                style: TextStyle(fontSize: 24),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(flashcard.answer),
            ],
          ),
        ),
      ),
    );
  }
}
