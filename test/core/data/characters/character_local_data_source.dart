import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taidam_tutor/core/data/characters/character_local_data_source.dart';
import 'package:taidam_tutor/core/data/characters/models/character.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CharacterLocalDataSource', () {
    late CharacterLocalDataSource dataSource;

    setUp(() {
      dataSource = CharacterLocalDataSource();
    });

    tearDown(() {
      dataSource = CharacterLocalDataSource();
    });

    test('initializes and loads characters from valid JSON file', () async {
      const jsonString = '''
          [
            {
              "id": "1",
              "name": "Character 1",
              "description": "Description 1",
              "imageUrl": "image1.png",
              "tags": ["tag1", "tag2"]
            },
            {
              "id": "2",
              "name": "Character 2",
              "description": "Description 2",
              "imageUrl": "image2.png",
              "tags": ["tag3"]
            }
          ]
          ''';

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async =>
            ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer),
      );

      await dataSource.init();
      final characters = await dataSource.getCharacters();

      expect(characters.length, 2);
      expect(characters[0], 'Character 1');
      expect(characters[1].tags, contains('tag3'));
    });

    test('returns empty list when JSON file is empty', () async {
      const jsonString = '[]';

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async =>
            ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer),
      );

      await dataSource.init();
      final characters = await dataSource.getCharacters();

      expect(characters, isEmpty);
    });

    test('handles invalid JSON format gracefully', () async {
      const jsonString = '{ invalid json }';

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async =>
            ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer),
      );

      await dataSource.init();
      final characters = await dataSource.getCharacters();

      expect(characters, isEmpty);
    });

    test('does not reinitialize if already initialized', () async {
      const jsonString = '''
          [
            {
              "id": "1",
              "name": "Character 1",
              "description": "Description 1",
              "imageUrl": "image1.png",
              "tags": ["tag1", "tag2"]
            }
          ]
          ''';

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async =>
            ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer),
      );

      await dataSource.init();
      await dataSource.init(); // Call init again
      final characters = await dataSource.getCharacters();

      expect(characters.length, 1);
    });

    test('returns empty list when file is missing', () async {
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async => null,
      );

      await dataSource.init();
      final characters = await dataSource.getCharacters();

      expect(characters, isEmpty);
    });
  });
}
