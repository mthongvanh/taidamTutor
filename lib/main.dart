import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taidam_tutor/core/data/characters/character_repository.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/core/di/dependency_manager.dart';
import 'package:taidam_tutor/feature/letter_search/letter_search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyManager().registerDependencies();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider<AppCubit>(
        create: (context) => AppCubit(),
        child: const App(),
      ),
    ),
  );
}

typedef InitGameParams = ({
  Character targetLetter,
  List<Character> allowedLetters
});

class AppCubit extends Cubit<InitGameParams?> {
  final _characterRepository = dm.get<CharacterRepository>();

  AppCubit() : super(null) {
    debugPrint('AppCubit initialized');
    init();
  }

  void init() {
    _characterRepository.getCharacters().then((value) {
      debugPrint('Characters loaded: $value');
      final randomLetter = value[Random().nextInt(value.length)];
      final randomAllowedLetters =
          value.where(((e) => e != randomLetter)).toList();

      randomAllowedLetters.shuffle();
      final allowedLetters = randomAllowedLetters.take(4).toList();
      allowedLetters.add(randomLetter);

      emit((targetLetter: randomLetter, allowedLetters: allowedLetters));
    }).catchError((error) {
      emit(null);
    });
  }

  void reload() {
    emit(null);
    init();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, InitGameParams?>(
      builder: (context, state) {
        final appState = state;
        if (appState == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return LetterSearchGame(
            targetLetter: appState.targetLetter,
            allowedLetters: appState.allowedLetters);
      },
    );
  }
}
