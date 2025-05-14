import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';
import 'package:taidam_tutor/core/di/dependency_manager.dart';
import 'package:taidam_tutor/feature/character_list/character_list.dart';
import 'package:taidam_tutor/feature/letter_search/letter_search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyManager().registerDependencies();
  final darkText = ThemeData.dark().textTheme;
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.bricolageGrotesqueTextTheme().copyWith(
          bodyLarge: GoogleFonts.latoTextTheme().bodyLarge,
          bodyMedium: GoogleFonts.latoTextTheme().bodyMedium,
          bodySmall: GoogleFonts.latoTextTheme().bodySmall,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.bricolageGrotesqueTextTheme(darkText).copyWith(
          bodyLarge: GoogleFonts.latoTextTheme(darkText).bodyLarge,
          bodyMedium: GoogleFonts.latoTextTheme(darkText).bodyMedium,
          bodySmall: GoogleFonts.latoTextTheme(darkText).bodySmall,
        ),
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

class AppCubit extends Cubit<int> {
  AppCubit() : super(0) {
    debugPrint('AppCubit initialized');
    init();
  }

  void init() {
    emit(0);
  }

  void reload() {
    emit(0);
    init();
  }

  void onItemTapped(int index) {
    emit(index);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(state),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt),
                label: 'Characters',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'Game',
              ),
            ],
            currentIndex: state,
            // selectedItemColor:
            //     Theme.of(context).primaryColor, // Or your preferred color
            unselectedItemColor: Colors.grey.shade700,
            onTap: context.read<AppCubit>().onItemTapped,
            showUnselectedLabels: true,
          ),
        );
      },
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    CharacterListPage(),
    LetterSearchGame(),
  ];
}
