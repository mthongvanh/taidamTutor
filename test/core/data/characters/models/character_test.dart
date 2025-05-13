import 'package:flutter_test/flutter_test.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';

void main() {
  group('Character Model', () {
    Character createSampleCharacter() {
      return Character(
        characterId: 1,
        character: 'ꪼ',
        audioFile: 'a1.mp3',
        sound: 'ah',
        characterType: 0,
        imageFile: 'character.svg',
        highLow: 'high',
        prePost: 'pre',
      );
    }

    test('fromJson creates a valid Character object', () {
      final json = {
        'characterId': 1,
        'character': 'ꪼ',
        'audioFile': 'a1.mp3',
        'sound': 'ah',
        'characterType': 0,
        'svg': 'character.svg',
        'highLow': 'high',
        'prePost': 'pre',
      };

      final character = Character.fromJson(json);

      expect(character.characterId, 1);
      expect(character.character, 'ꪼ');
      expect(character.audioFile, 'a1.mp3');
      expect(character.sound, 'ah');
      expect(character.characterType, 0);
      expect(character.imageFile, 'character.svg');
      expect(character.highLow, 'high');
      expect(character.prePost, 'pre');
    });

    test('toJson returns a valid JSON map', () {
      final character = createSampleCharacter();

      final json = character.toJson();

      expect(json['characterId'], 1);
      expect(json['character'], 'ꪼ');
      expect(json['audioFile'], 'a1.mp3');
      expect(json['sound'], 'ah');
      expect(json['characterType'], 0);
      expect(json['svg'], 'character.svg');
      expect(json['highLow'], 'high');
      expect(json['prePost'], 'pre');
    });

    test('equality operator returns true for identical objects', () {
      final character1 = createSampleCharacter();
      final character2 = createSampleCharacter();

      expect(character1, character2);
    });

    test('equality operator returns false for different objects', () {
      final character1 = createSampleCharacter();
      final character2 = Character(
        characterId: 2,
        character: 'ꪹ',
        audioFile: 'a2.mp3',
        sound: 'oh',
        characterType: 1,
        imageFile: 'character2.svg',
        highLow: 'low',
        prePost: 'post',
      );

      expect(character1, isNot(character2));
    });

    test('handles null highLow and prePost values correctly', () {
      final json = {
        'characterId': 3,
        'character': 'ꪺ',
        'audioFile': 'a3.mp3',
        'sound': 'uh',
        'characterType': 1,
        'svg': 'character3.svg',
        'highLow': null,
        'prePost': null,
      };

      final character = Character.fromJson(json);

      expect(character.highLow, isNull);
      expect(character.prePost, isNull);
    });
  });
}
